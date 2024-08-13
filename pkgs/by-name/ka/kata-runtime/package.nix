# Derived from https://github.com/colemickens/nixpkgs-kubernetes
{ stdenv
, lib
, buildGoModule
, callPackage
, fetchFromGitHub
, fetchzip
, go
, qemu_kvm
, makeWrapper
, pkgsStatic
, virtiofsd
, yq-go

, static ? true
}:

let
  version = "3.7.0";

  kata-images = fetchzip {
    name = "kata-images-${version}";
    url = "https://github.com/kata-containers/kata-containers/releases/download/${version}/kata-static-${version}-amd64.tar.xz";
    sha256 = "sha256-6ySKAqrbHDRgVlI7wm2p4Uw96ZMzUpP00liujxlruSM=";

    postFetch = ''
      mv $out/kata/share/kata-containers kata-containers
      rm -r $out
      mkdir -p $out/share
      mv kata-containers $out/share/kata-containers
    '';
  };

in

buildGoModule (rec {
  pname = "kata-runtime";
  inherit version;

  # https://github.com/NixOS/nixpkgs/issues/25959
  hardeningDisable = [ "fortify" ];

  src = fetchFromGitHub {
    owner = "kata-containers";
    repo = "kata-containers";
    rev = version;
    sha256 = "sha256-Ir+/ZZJHm6E+044wczU3UvL+Py9Wprgw2QKJaYyDrKU=";
  };

  sourceRoot = "source/src/runtime";

  vendorHash = null;

  dontConfigure = true;

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "DEFAULT_HYPERVISOR=qemu"
    "HYPERVISORS=qemu"
    "QEMUPATH=${qemu_kvm}/bin/qemu-system-x86_64"
  ];

  buildPhase = ''
    runHook preBuild
    mkdir -p $TMPDIR/gopath/bin
    ln -s ${yq-go}/bin/yq $TMPDIR/gopath/bin/yq
    HOME=$TMPDIR GOPATH=$TMPDIR/gopath make ${toString makeFlags}
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    HOME=$TMPDIR GOPATH=$TMPDIR/gopath make ${toString makeFlags} install
    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-qemu-v2
    ln -s $out/bin/containerd-shim-kata-v2 $out/bin/containerd-shim-kata-clh-v2

    # Update a few paths to the Nix-provided versions: kata-images, virtiofsd, and qemu_kvm
    sed -i \
      -e "s!$out/share/kata-containers!${kata-images}/share/kata-containers!" \
      -e "s!^virtio_fs_daemon.*!virtio_fs_daemon=\"${virtiofsd}/bin/virtiofsd\"!" \
      -e "s!^valid_virtio_fs_daemon_paths.*!valid_virtio_fs_daemon_paths=[\"${qemu_kvm}/libexec/virtiofsd\"]!" \
      "$out/share/defaults/kata-containers/"*.toml

    runHook postInstall
  '';

  passthru = {
    inherit kata-images;
  };

  meta = {
    description = "Kata Containers is an open source project and community working to build a standard implementation of lightweight Virtual Machines (VMs) that feel and perform like containers, but provide the workload isolation and security advantages of VMs.";
    homepage = "https://github.com/kata-containers/kata-containers";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ thomasjm ];
    platforms = lib.platforms.unix;
  };
} // lib.optionalAttrs static {
  # CGO_ENABLED = 0;

  CGO_ENABLED = 1;
  ldflags = [
    "-linkmode external"
    "-extldflags -static"
  ];

  preBuild = ''
    export CC=${pkgsStatic.stdenv.cc}/bin/${pkgsStatic.stdenv.cc.targetPrefix}cc
  '';
})
