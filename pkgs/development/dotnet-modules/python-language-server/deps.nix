{ fetchurl }: let

  fetchNuGet = { name, version, sha256 }: fetchurl {
    inherit sha256;
    url = "https://www.nuget.org/api/v2/package/${name}/${version}";
  };

in [

  (fetchNuGet {
    name = "Ben.Demystifier";
    version = "0.1.6";
    sha256 = "03rk7imb2k3iass507rkr9chdnyk4h8ppyf20cdz3c2m3v1a5k9n";
  })

  (fetchNuGet {
    name = "Castle.Core";
    version = "4.4.0";
    sha256 = "0rpcbmyhckvlvp6vbzpj03c1gqz56ixc6f15vgmxmyf1g40c24pf";
  })

  (fetchNuGet {
    name = "FluentAssertions";
    version = "5.9.0";
    sha256 = "11mpnl6aar2yn7l6b1k4m3rdnl82ydmqbsja4rn84dhz1qdzfp8x";
  })

  (fetchNuGet {
    name = "LiteDB";
    version = "4.1.4";
    sha256 = "1g9258mv3jm9ps2s5wcxbmszh9nqiiw3d9nrfqis8x72jqiqi6js";
  })

  (fetchNuGet {
    name = "MessagePack";
    version = "2.1.90";
    sha256 = "1j5wjl7aq7nn5ga3j6zaaivdf2wlfyd7w66ak0i7krgrmv26lb8i";
  })

  (fetchNuGet {
    name = "MessagePack.Annotations";
    version = "2.1.90";
    sha256 = "08sghhwbz8h7ji9lg0klhwcyndxg6v11pq9jac975sb38samnm11";
  })

  (fetchNuGet {
    name = "MicroBuild.Core";
    version = "0.3.0";
    sha256 = "190d755l60j3l5m1661wj19gj9w6ngza56q3vkijkkmbbabdmqln";
  })

  (fetchNuGet {
    name = "Microsoft.AspNetCore.App.Ref";
    version = "3.0.1";
    sha256 = "0k2ry757qhm99xwm0wh4zalxn9nmxhfswd184z1fjr42szr511fb";
  })

  (fetchNuGet {
    name = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "3.0.2";
    sha256 = "0d4r744n3bk4v7ddfjpy5ils150h0693bil3c7v27n84037hqndj";
  })

  (fetchNuGet {
    name = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "3.0.3";
    sha256 = "1jcqy8i9fzb1pmkazi80yqr09zi5nk30n57i46ggr5ky45jngfq9";
  })

  (fetchNuGet {
    name = "Microsoft.AspNetCore.App.Runtime.linux-x64";
    version = "3.1.3";
    sha256 = "0kvnzb9xjii48kg30ac63qdf0fn1y8j3nblbrfaqv2aiy6kp0iwn";
  })

  (fetchNuGet {
    name = "Microsoft.Bcl.AsyncInterfaces";
    version = "1.0.0";
    sha256 = "00dx5armvkqjxvkldz3invdlck9nj7w21dlsr2aqp1rqbyrbsbbh";
  })

  (fetchNuGet {
    name = "Microsoft.CodeCoverage";
    version = "16.5.0";
    sha256 = "0610wzn4qyywf9lb4538vwqhprxc4g0g7gjbmnjzvx97jr5nd5mf";
  })

  (fetchNuGet {
    name = "Microsoft.CSharp";
    version = "4.0.1";
    sha256 = "0zxc0apx1gcx361jlq8smc9pfdgmyjh6hpka8dypc9w23nlsh6yj";
  })

  (fetchNuGet {
    name = "Microsoft.Extensions.FileSystemGlobbing";
    version = "3.1.2";
    sha256 = "1zwvzp0607irs7irfbq8vnclg5nj2jpyggw9agm4a32la5ngg27m";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Host.linux-x64";
    version = "3.0.2";
    sha256 = "0y14y2x3wbi44i23ndmf4323cii8wrqw9s289gcab3s393l71sf5";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Host.linux-x64";
    version = "3.1.3";
    sha256 = "013ibnhsimgqj5l2dqma035xvsvrb47bn65z6xbxgg88383hpgvw";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Ref";
    version = "3.0.0";
    sha256 = "1qi382157ln7yngazvr3nskpjkab4x8sqx11l13xyg56vyyjyyiw";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Ref";
    version = "3.1.0";
    sha256 = "08svsiilx9spvjamcnjswv0dlpdrgryhr3asdz7cvnl914gjzq4y";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Runtime.linux-x64";
    version = "3.0.2";
    sha256 = "1h6d0nl495k0bh4my43l578l7m8qwah7ll42aax7jrib2py354f1";
  })

  (fetchNuGet {
    name = "Microsoft.NetCore.App.Runtime.linux-x64";
    version = "3.1.3";
    sha256 = "1ynhzsr8a0hfby2wjhzkdiimj18izgfzp7m2yp3pby2iwb4v3xy9";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "1.1.0";
    sha256 = "08vh1r12g6ykjygq5d3vq09zylgb84l63k49jc4v8faw9g93iqqm";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "1.1.1";
    sha256 = "164wycgng4mi9zqi2pnsf1pq6gccbqvw6ib916mqizgjmd8f44pj";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "2.0.0";
    sha256 = "1fk2fk2639i7nzy58m9dvpdnzql4vb8yl8vr19r2fp8lmj9w2jr0";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Platforms";
    version = "3.1.0";
    sha256 = "1gc1x8f95wk8yhgznkwsg80adk1lc65v9n5rx4yaa4bc5dva0z3j";
  })

  (fetchNuGet {
    name = "Microsoft.NETCore.Targets";
    version = "1.1.0";
    sha256 = "193xwf33fbm0ni3idxzbr5fdq3i2dlfgihsac9jj7whj0gd902nh";
  })

  (fetchNuGet {
    name = "Microsoft.NET.Test.Sdk";
    version = "16.5.0";
    sha256 = "19f5bvzci5mmfz81jwc4dax4qdf7w4k67n263383mn8mawf22bfq";
  })

  (fetchNuGet {
    name = "Microsoft.TestPlatform.ObjectModel";
    version = "16.5.0";
    sha256 = "02h7j1fr0fwcggn0wgddh59k8b2wmly3snckwhswzqvks5rvfnnw";
  })

  (fetchNuGet {
    name = "Microsoft.TestPlatform.TestHost";
    version = "16.5.0";
    sha256 = "08cvss66lqa92h55dxkbrzn796jckhlyj53zz22x3qyr6xi21v5v";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Threading";
    version = "16.4.33";
    sha256 = "09djx2xz22w48csd0bkpwi1rgpjpaj3mml16wfy8jlsnc66swmnh";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Threading";
    version = "16.4.45";
    sha256 = "16p61kxsnwanp3nac0gkarl7a94c02qyqjzdkijl5va9k3fa97m6";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Threading.Analyzers";
    version = "16.4.45";
    sha256 = "12m0f037pz3ynm69810p4c96nrlnqihx6w4qyrs0kqsxiajf16jc";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Validation";
    version = "15.3.15";
    sha256 = "1v3r2rlichlvxjrmj1grii1blnl9lp9npg2p6q3q4j6lamskxa9r";
  })

  (fetchNuGet {
    name = "Microsoft.VisualStudio.Validation";
    version = "15.5.31";
    sha256 = "1ah99rn922qa0sd2k3h64m324f2r32pw8cn4cfihgvwx4qdrpmgw";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Primitives";
    version = "4.3.0";
    sha256 = "0j0c1wj4ndj21zsgivsc24whiya605603kxrbiw6wkfdync464wq";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.5.0";
    sha256 = "1zapbz161ji8h82xiajgriq6zgzmb1f3ar517p2h63plhsq5gh2q";
  })

  (fetchNuGet {
    name = "Microsoft.Win32.Registry";
    version = "4.7.0";
    sha256 = "0bx21jjbs7l5ydyw4p6cn07chryxpmchq2nl5pirzz4l3b0q4dgs";
  })

  (fetchNuGet {
    name = "MSTest.TestAdapter";
    version = "2.1.0";
    sha256 = "1g1v8yjnk4nr1c36k3cz116889bnpiw1i1jkmqnpb19wms7sq7cz";
  })

  (fetchNuGet {
    name = "MSTest.TestFramework";
    version = "2.1.0";
    sha256 = "0mac4h7ylw953chclhz0lrn19yks3bab9dn9x9fpjqi7309gid0p";
  })

  (fetchNuGet {
    name = "Nerdbank.Streams";
    version = "2.4.60";
    sha256 = "01554nbs6dj4fjd59b95kaw84j27kfb5y5ixjbl23nh62kpgrd3r";
  })

  (fetchNuGet {
    name = "NETStandard.Library";
    version = "1.6.1";
    sha256 = "1z70wvsx2d847a2cjfii7b83pjfs34q05gb037fdjikv5kbagml8";
  })

  (fetchNuGet {
    name = "NETStandard.Library";
    version = "2.0.3";
    sha256 = "1fn9fxppfcg4jgypp2pmrpr6awl3qz1xmnri0cygpkwvyx27df1y";
  })

  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "12.0.2";
    sha256 = "0w2fbji1smd2y7x25qqibf1qrznmv4s6s0jvrbvr6alb7mfyqvh5";
  })

  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "12.0.3";
    sha256 = "17dzl305d835mzign8r15vkmav2hq8l6g7942dfjpnzr17wwl89x";
  })

  (fetchNuGet {
    name = "NewtonSoft.Json";
    version = "12.0.3";
    sha256 = "17dzl305d835mzign8r15vkmav2hq8l6g7942dfjpnzr17wwl89x";
  })

  (fetchNuGet {
    name = "Newtonsoft.Json";
    version = "9.0.1";
    sha256 = "0mcy0i7pnfpqm4pcaiyzzji4g0c8i3a5gjz28rrr28110np8304r";
  })

  (fetchNuGet {
    name = "NSubstitute";
    version = "4.2.1";
    sha256 = "0wgfjh032qds994fmgxvsg88nhgjrx7p9rnv6z678jm62qi14asy";
  })

  (fetchNuGet {
    name = "NuGet.Frameworks";
    version = "5.0.0";
    sha256 = "18ijvmj13cwjdrrm52c8fpq021531zaz4mj4b4zapxaqzzxf2qjr";
  })

  (fetchNuGet {
    name = "runtime.any.System.Collections";
    version = "4.3.0";
    sha256 = "0bv5qgm6vr47ynxqbnkc7i797fdi8gbjjxii173syrx14nmrkwg0";
  })

  (fetchNuGet {
    name = "runtime.any.System.Diagnostics.Tools";
    version = "4.3.0";
    sha256 = "1wl76vk12zhdh66vmagni66h5xbhgqq7zkdpgw21jhxhvlbcl8pk";
  })

  (fetchNuGet {
    name = "runtime.any.System.Diagnostics.Tracing";
    version = "4.3.0";
    sha256 = "00j6nv2xgmd3bi347k00m7wr542wjlig53rmj28pmw7ddcn97jbn";
  })

  (fetchNuGet {
    name = "runtime.any.System.Globalization";
    version = "4.3.0";
    sha256 = "1daqf33hssad94lamzg01y49xwndy2q97i2lrb7mgn28656qia1x";
  })

  (fetchNuGet {
    name = "runtime.any.System.Globalization.Calendars";
    version = "4.3.0";
    sha256 = "1ghhhk5psqxcg6w88sxkqrc35bxcz27zbqm2y5p5298pv3v7g201";
  })

  (fetchNuGet {
    name = "runtime.any.System.IO";
    version = "4.3.0";
    sha256 = "0l8xz8zn46w4d10bcn3l4yyn4vhb3lrj2zw8llvz7jk14k4zps5x";
  })

  (fetchNuGet {
    name = "runtime.any.System.Reflection";
    version = "4.3.0";
    sha256 = "02c9h3y35pylc0zfq3wcsvc5nqci95nrkq0mszifc0sjx7xrzkly";
  })

  (fetchNuGet {
    name = "runtime.any.System.Reflection.Extensions";
    version = "4.3.0";
    sha256 = "0zyri97dfc5vyaz9ba65hjj1zbcrzaffhsdlpxc9bh09wy22fq33";
  })

  (fetchNuGet {
    name = "runtime.any.System.Reflection.Primitives";
    version = "4.3.0";
    sha256 = "0x1mm8c6iy8rlxm8w9vqw7gb7s1ljadrn049fmf70cyh42vdfhrf";
  })

  (fetchNuGet {
    name = "runtime.any.System.Resources.ResourceManager";
    version = "4.3.0";
    sha256 = "03kickal0iiby82wa5flar18kyv82s9s6d4xhk5h4bi5kfcyfjzl";
  })

  (fetchNuGet {
    name = "runtime.any.System.Runtime";
    version = "4.3.0";
    sha256 = "1cqh1sv3h5j7ixyb7axxbdkqx6cxy00p4np4j91kpm492rf4s25b";
  })

  (fetchNuGet {
    name = "runtime.any.System.Runtime.Handles";
    version = "4.3.0";
    sha256 = "0bh5bi25nk9w9xi8z23ws45q5yia6k7dg3i4axhfqlnj145l011x";
  })

  (fetchNuGet {
    name = "runtime.any.System.Runtime.InteropServices";
    version = "4.3.0";
    sha256 = "0c3g3g3jmhlhw4klrc86ka9fjbl7i59ds1fadsb2l8nqf8z3kb19";
  })

  (fetchNuGet {
    name = "runtime.any.System.Text.Encoding";
    version = "4.3.0";
    sha256 = "0aqqi1v4wx51h51mk956y783wzags13wa7mgqyclacmsmpv02ps3";
  })

  (fetchNuGet {
    name = "runtime.any.System.Text.Encoding.Extensions";
    version = "4.3.0";
    sha256 = "0lqhgqi0i8194ryqq6v2gqx0fb86db2gqknbm0aq31wb378j7ip8";
  })

  (fetchNuGet {
    name = "runtime.any.System.Threading.Tasks";
    version = "4.3.0";
    sha256 = "03mnvkhskbzxddz4hm113zsch1jyzh2cs450dk3rgfjp8crlw1va";
  })

  (fetchNuGet {
    name = "runtime.any.System.Threading.Timer";
    version = "4.3.0";
    sha256 = "0aw4phrhwqz9m61r79vyfl5la64bjxj8l34qnrcwb28v49fg2086";
  })

  (fetchNuGet {
    name = "runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "16rnxzpk5dpbbl1x354yrlsbvwylrq456xzpsha1n9y3glnhyx9d";
  })

  (fetchNuGet {
    name = "runtime.debian.8-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0rwpqngkqiapqc5c2cpkj7idhngrgss5qpnqg0yh40mbyflcxf8i";
  })

  (fetchNuGet {
    name = "runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0hkg03sgm2wyq8nqk6dbm9jh5vcq57ry42lkqdmfklrw89lsmr59";
  })

  (fetchNuGet {
    name = "runtime.fedora.23-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1n06gxwlinhs0w7s8a94r1q3lwqzvynxwd3mp10ws9bg6gck8n4r";
  })

  (fetchNuGet {
    name = "runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0c2p354hjx58xhhz7wv6div8xpi90sc6ibdm40qin21bvi7ymcaa";
  })

  (fetchNuGet {
    name = "runtime.fedora.24-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0404wqrc7f2yc0wxv71y3nnybvqx8v4j9d47hlscxy759a525mc3";
  })

  (fetchNuGet {
    name = "runtime.native.System";
    version = "4.3.0";
    sha256 = "15hgf6zaq9b8br2wi1i3x0zvmk410nlmsmva9p0bbg73v6hml5k4";
  })

  (fetchNuGet {
    name = "runtime.native.System.IO.Compression";
    version = "4.3.0";
    sha256 = "1vvivbqsk6y4hzcid27pqpm5bsi6sc50hvqwbcx8aap5ifrxfs8d";
  })

  (fetchNuGet {
    name = "runtime.native.System.Net.Http";
    version = "4.3.0";
    sha256 = "1n6rgz5132lcibbch1qlf0g9jk60r0kqv087hxc0lisy50zpm7kk";
  })

  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "1b61p6gw1m02cc1ry996fl49liiwky6181dzr873g9ds92zl326q";
  })

  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "18pzfdlwsg2nb1jjjjzyb5qlgy6xjxzmhnfaijq5s2jw3cm3ab97";
  })

  (fetchNuGet {
    name = "runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0zy5r25jppz48i2bkg8b9lfig24xixg6nm3xyr1379zdnqnpm8f6";
  })

  (fetchNuGet {
    name = "runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0qyynf9nz5i7pc26cwhgi8j62ps27sqmf78ijcfgzab50z9g8ay3";
  })

  (fetchNuGet {
    name = "runtime.opensuse.13.2-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "096ch4n4s8k82xga80lfmpimpzahd2ip1mgwdqgar0ywbbl6x438";
  })

  (fetchNuGet {
    name = "runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "1klrs545awhayryma6l7g2pvnp9xy4z0r1i40r80zb45q3i9nbyf";
  })

  (fetchNuGet {
    name = "runtime.opensuse.42.1-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1dm8fifl7rf1gy7lnwln78ch4rw54g0pl5g1c189vawavll7p6rj";
  })

  (fetchNuGet {
    name = "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.Apple";
    version = "4.3.0";
    sha256 = "10yc8jdrwgcl44b4g93f1ds76b176bajd3zqi2faf5rvh1vy9smi";
  })

  (fetchNuGet {
    name = "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0zcxjv5pckplvkg0r6mw3asggm7aqzbdjimhvsasb0cgm59x09l3";
  })

  (fetchNuGet {
    name = "runtime.osx.10.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1m9z1k9kzva9n9kwinqxl97x2vgl79qhqjlv17k9s2ymcyv2bwr6";
  })

  (fetchNuGet {
    name = "runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0vhynn79ih7hw7cwjazn87rm9z9fj0rvxgzlab36jybgcpcgphsn";
  })

  (fetchNuGet {
    name = "runtime.rhel.7-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1cpx56mcfxz7cpn57wvj18sjisvzq8b5vd9rw16ihd2i6mcp3wa1";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "160p68l2c7cqmyqjwxydcvgw7lvl1cr0znkw8fp24d1by9mqc8p3";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.14.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "15gsm1a8jdmgmf8j5v1slfz8ks124nfdhk2vxs2rw3asrxalg8hi";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "15zrc8fgd8zx28hdghcj5f5i34wf3l6bq5177075m2bc2j34jrqy";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.04-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "0q0n5q1r1wnqmr5i5idsrd9ywl33k0js4pngkwq9p368mbxp8x1w";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "1p4dgxax6p7rlgj4q73k73rslcnz4wdcv8q2flg1s8ygwcm58ld5";
  })

  (fetchNuGet {
    name = "runtime.ubuntu.16.10-x64.runtime.native.System.Security.Cryptography.OpenSsl";
    version = "4.3.2";
    sha256 = "1x0g58pbpjrmj2x2qw17rdwwnrcl0wvim2hdwz48lixvwvp22n9c";
  })

  (fetchNuGet {
    name = "runtime.unix.Microsoft.Win32.Primitives";
    version = "4.3.0";
    sha256 = "0y61k9zbxhdi0glg154v30kkq7f8646nif8lnnxbvkjpakggd5id";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Console";
    version = "4.3.0";
    sha256 = "1pfpkvc6x2if8zbdzg9rnc5fx51yllprl8zkm5npni2k50lisy80";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Diagnostics.Debug";
    version = "4.3.0";
    sha256 = "1lps7fbnw34bnh3lm31gs5c0g0dh7548wfmb8zz62v0zqz71msj5";
  })

  (fetchNuGet {
    name = "runtime.unix.System.IO.FileSystem";
    version = "4.3.0";
    sha256 = "14nbkhvs7sji5r1saj2x8daz82rnf9kx28d3v2qss34qbr32dzix";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Net.Primitives";
    version = "4.3.0";
    sha256 = "0bdnglg59pzx9394sy4ic66kmxhqp8q8bvmykdxcbs5mm0ipwwm4";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Net.Sockets";
    version = "4.3.0";
    sha256 = "03npdxzy8gfv035bv1b9rz7c7hv0rxl5904wjz51if491mw0xy12";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Private.Uri";
    version = "4.3.0";
    sha256 = "1jx02q6kiwlvfksq1q9qr17fj78y5v6mwsszav4qcz9z25d5g6vk";
  })

  (fetchNuGet {
    name = "runtime.unix.System.Runtime.Extensions";
    version = "4.3.0";
    sha256 = "0pnxxmm8whx38dp6yvwgmh22smknxmqs5n513fc7m4wxvs1bvi4p";
  })

  (fetchNuGet {
    name = "StreamJsonRpc";
    version = "2.3.103";
    sha256 = "0z8ahxkbbrzsn56ylzlciriiid4bslf6y1rk49wzahwpvzlik1iw";
  })

  (fetchNuGet {
    name = "System.AppContext";
    version = "4.3.0";
    sha256 = "1649qvy3dar900z3g817h17nl8jp4ka5vcfmsr05kh0fshn7j3ya";
  })

  (fetchNuGet {
    name = "System.Buffers";
    version = "4.3.0";
    sha256 = "0fgns20ispwrfqll4q1zc1waqcmylb3zc50ys9x8zlwxh9pmd9jy";
  })

  (fetchNuGet {
    name = "System.Buffers";
    version = "4.5.0";
    sha256 = "1ywfqn4md6g3iilpxjn5dsr0f5lx6z0yvhqp4pgjcamygg73cz2c";
  })

  (fetchNuGet {
    name = "System.Collections";
    version = "4.0.11";
    sha256 = "1ga40f5lrwldiyw6vy67d0sg7jd7ww6kgwbksm19wrvq9hr0bsm6";
  })

  (fetchNuGet {
    name = "System.Collections";
    version = "4.3.0";
    sha256 = "19r4y64dqyrq6k4706dnyhhw7fs24kpp3awak7whzss39dakpxk9";
  })

  (fetchNuGet {
    name = "System.Collections.Concurrent";
    version = "4.3.0";
    sha256 = "0wi10md9aq33jrkh2c24wr2n9hrpyamsdhsxdcnf43b7y86kkii8";
  })

  (fetchNuGet {
    name = "System.Collections.Immutable";
    version = "1.5.0";
    sha256 = "1d5gjn5afnrf461jlxzawcvihz195gayqpcfbv6dd7pxa9ialn06";
  })

  (fetchNuGet {
    name = "System.Collections.NonGeneric";
    version = "4.3.0";
    sha256 = "07q3k0hf3mrcjzwj8fwk6gv3n51cb513w4mgkfxzm3i37sc9kz7k";
  })

  (fetchNuGet {
    name = "System.Collections.Specialized";
    version = "4.3.0";
    sha256 = "1sdwkma4f6j85m3dpb53v9vcgd0zyc9jb33f8g63byvijcj39n20";
  })

  (fetchNuGet {
    name = "System.ComponentModel";
    version = "4.3.0";
    sha256 = "0986b10ww3nshy30x9sjyzm0jx339dkjxjj3401r3q0f6fx2wkcb";
  })

  (fetchNuGet {
    name = "System.ComponentModel.Primitives";
    version = "4.3.0";
    sha256 = "1svfmcmgs0w0z9xdw2f2ps05rdxmkxxhf0l17xk9l1l8xfahkqr0";
  })

  (fetchNuGet {
    name = "System.ComponentModel.TypeConverter";
    version = "4.3.0";
    sha256 = "17ng0p7v3nbrg3kycz10aqrrlw4lz9hzhws09pfh8gkwicyy481x";
  })

  (fetchNuGet {
    name = "System.Configuration.ConfigurationManager";
    version = "4.4.0";
    sha256 = "1hjgmz47v5229cbzd2pwz2h0dkq78lb2wp9grx8qr72pb5i0dk7v";
  })

  (fetchNuGet {
    name = "System.Console";
    version = "4.3.0";
    sha256 = "1flr7a9x920mr5cjsqmsy9wgnv3lvd0h1g521pdr1lkb2qycy7ay";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Debug";
    version = "4.0.11";
    sha256 = "0gmjghrqmlgzxivd2xl50ncbglb7ljzb66rlx8ws6dv8jm0d5siz";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Debug";
    version = "4.3.0";
    sha256 = "00yjlf19wjydyr6cfviaph3vsjzg3d5nvnya26i2fvfg53sknh3y";
  })

  (fetchNuGet {
    name = "System.Diagnostics.DiagnosticSource";
    version = "4.3.0";
    sha256 = "0z6m3pbiy0qw6rn3n209rrzf9x1k4002zh90vwcrsym09ipm2liq";
  })

  (fetchNuGet {
    name = "System.Diagnostics.TextWriterTraceListener";
    version = "4.3.0";
    sha256 = "09db74f36wkwg30f7v7zhz1yhkyrnl5v6bdwljq1jdfgzcfch7c3";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Tools";
    version = "4.3.0";
    sha256 = "0in3pic3s2ddyibi8cvgl102zmvp9r9mchh82ns9f0ms4basylw1";
  })

  (fetchNuGet {
    name = "System.Diagnostics.TraceSource";
    version = "4.3.0";
    sha256 = "1kyw4d7dpjczhw6634nrmg7yyyzq72k75x38y0l0nwhigdlp1766";
  })

  (fetchNuGet {
    name = "System.Diagnostics.Tracing";
    version = "4.3.0";
    sha256 = "1m3bx6c2s958qligl67q7grkwfz3w53hpy7nc97mh6f7j5k168c4";
  })

  (fetchNuGet {
    name = "System.Dynamic.Runtime";
    version = "4.0.11";
    sha256 = "1pla2dx8gkidf7xkciig6nifdsb494axjvzvann8g2lp3dbqasm9";
  })

  (fetchNuGet {
    name = "System.Dynamic.Runtime";
    version = "4.3.0";
    sha256 = "1d951hrvrpndk7insiag80qxjbf2y0y39y8h5hnq9612ws661glk";
  })

  (fetchNuGet {
    name = "System.Globalization";
    version = "4.0.11";
    sha256 = "070c5jbas2v7smm660zaf1gh0489xanjqymkvafcs4f8cdrs1d5d";
  })

  (fetchNuGet {
    name = "System.Globalization";
    version = "4.3.0";
    sha256 = "1cp68vv683n6ic2zqh2s1fn4c2sd87g5hpp6l4d4nj4536jz98ki";
  })

  (fetchNuGet {
    name = "System.Globalization.Calendars";
    version = "4.3.0";
    sha256 = "1xwl230bkakzzkrggy1l1lxmm3xlhk4bq2pkv790j5lm8g887lxq";
  })

  (fetchNuGet {
    name = "System.Globalization.Extensions";
    version = "4.3.0";
    sha256 = "02a5zfxavhv3jd437bsncbhd2fp1zv4gxzakp1an9l6kdq1mcqls";
  })

  (fetchNuGet {
    name = "System.IO";
    version = "4.1.0";
    sha256 = "1g0yb8p11vfd0kbkyzlfsbsp5z44lwsvyc0h3dpw6vqnbi035ajp";
  })

  (fetchNuGet {
    name = "System.IO";
    version = "4.3.0";
    sha256 = "05l9qdrzhm4s5dixmx68kxwif4l99ll5gqmh7rqgw554fx0agv5f";
  })

  (fetchNuGet {
    name = "System.IO.Compression";
    version = "4.3.0";
    sha256 = "084zc82yi6yllgda0zkgl2ys48sypiswbiwrv7irb3r0ai1fp4vz";
  })

  (fetchNuGet {
    name = "System.IO.Compression.ZipFile";
    version = "4.3.0";
    sha256 = "1yxy5pq4dnsm9hlkg9ysh5f6bf3fahqqb6p8668ndy5c0lk7w2ar";
  })

  (fetchNuGet {
    name = "System.IO.FileSystem";
    version = "4.3.0";
    sha256 = "0z2dfrbra9i6y16mm9v1v6k47f0fm617vlb7s5iybjjsz6g1ilmw";
  })

  (fetchNuGet {
    name = "System.IO.FileSystem.Primitives";
    version = "4.3.0";
    sha256 = "0j6ndgglcf4brg2lz4wzsh1av1gh8xrzdsn9f0yznskhqn1xzj9c";
  })

  (fetchNuGet {
    name = "System.IO.Pipelines";
    version = "4.5.3";
    sha256 = "1z44vn1qp866lkx78cfqdd4vs7xn1hcfn7in6239sq2kgf5qiafb";
  })

  (fetchNuGet {
    name = "System.IO.Pipelines";
    version = "4.6.0";
    sha256 = "0r9ygjbxpyi6jgb67qnpbp42b7yvvhgmcjxnb50k3lb416claavh";
  })

  (fetchNuGet {
    name = "System.Linq";
    version = "4.1.0";
    sha256 = "1ppg83svb39hj4hpp5k7kcryzrf3sfnm08vxd5sm2drrijsla2k5";
  })

  (fetchNuGet {
    name = "System.Linq";
    version = "4.3.0";
    sha256 = "1w0gmba695rbr80l1k2h4mrwzbzsyfl2z4klmpbsvsg5pm4a56s7";
  })

  (fetchNuGet {
    name = "System.Linq.Expressions";
    version = "4.1.0";
    sha256 = "1gpdxl6ip06cnab7n3zlcg6mqp7kknf73s8wjinzi4p0apw82fpg";
  })

  (fetchNuGet {
    name = "System.Linq.Expressions";
    version = "4.3.0";
    sha256 = "0ky2nrcvh70rqq88m9a5yqabsl4fyd17bpr63iy2mbivjs2nyypv";
  })

  (fetchNuGet {
    name = "System.Memory";
    version = "4.5.3";
    sha256 = "0naqahm3wljxb5a911d37mwjqjdxv9l0b49p5dmfyijvni2ppy8a";
  })

  (fetchNuGet {
    name = "System.Net.Http";
    version = "4.3.0";
    sha256 = "1i4gc757xqrzflbk7kc5ksn20kwwfjhw9w7pgdkn19y3cgnl302j";
  })

  (fetchNuGet {
    name = "System.Net.Http";
    version = "4.3.4";
    sha256 = "0kdp31b8819v88l719j6my0yas6myv9d1viql3qz5577mv819jhl";
  })

  (fetchNuGet {
    name = "System.Net.NameResolution";
    version = "4.3.0";
    sha256 = "15r75pwc0rm3vvwsn8rvm2krf929mjfwliv0mpicjnii24470rkq";
  })

  (fetchNuGet {
    name = "System.Net.Primitives";
    version = "4.3.0";
    sha256 = "0c87k50rmdgmxx7df2khd9qj7q35j9rzdmm2572cc55dygmdk3ii";
  })

  (fetchNuGet {
    name = "System.Net.Sockets";
    version = "4.3.0";
    sha256 = "1ssa65k6chcgi6mfmzrznvqaxk8jp0gvl77xhf1hbzakjnpxspla";
  })

  (fetchNuGet {
    name = "System.Net.WebSockets";
    version = "4.3.0";
    sha256 = "1gfj800078kggcgl0xyl00a6y5k4wwh2k2qm69rjy22wbmq7fy4p";
  })

  (fetchNuGet {
    name = "System.ObjectModel";
    version = "4.0.12";
    sha256 = "1sybkfi60a4588xn34nd9a58png36i0xr4y4v4kqpg8wlvy5krrj";
  })

  (fetchNuGet {
    name = "System.ObjectModel";
    version = "4.3.0";
    sha256 = "191p63zy5rpqx7dnrb3h7prvgixmk168fhvvkkvhlazncf8r3nc2";
  })

  (fetchNuGet {
    name = "System.Private.Uri";
    version = "4.3.0";
    sha256 = "04r1lkdnsznin0fj4ya1zikxiqr0h6r6a1ww2dsm60gqhdrf0mvx";
  })

  (fetchNuGet {
    name = "System.Reflection";
    version = "4.1.0";
    sha256 = "1js89429pfw79mxvbzp8p3q93il6rdff332hddhzi5wqglc4gml9";
  })

  (fetchNuGet {
    name = "System.Reflection";
    version = "4.3.0";
    sha256 = "0xl55k0mw8cd8ra6dxzh974nxif58s3k1rjv1vbd7gjbjr39j11m";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit";
    version = "4.0.1";
    sha256 = "0ydqcsvh6smi41gyaakglnv252625hf29f7kywy2c70nhii2ylqp";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit";
    version = "4.3.0";
    sha256 = "11f8y3qfysfcrscjpjym9msk7lsfxkk4fmz9qq95kn3jd0769f74";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit";
    version = "4.6.0";
    sha256 = "18h375q5bn9h7swxnk4krrxym1dxmi9bm26p89xps9ygrj4q6zqw";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit.ILGeneration";
    version = "4.0.1";
    sha256 = "1pcd2ig6bg144y10w7yxgc9d22r7c7ww7qn1frdfwgxr24j9wvv0";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit.ILGeneration";
    version = "4.3.0";
    sha256 = "0w1n67glpv8241vnpz1kl14sy7zlnw414aqwj4hcx5nd86f6994q";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit.Lightweight";
    version = "4.3.0";
    sha256 = "0ql7lcakycrvzgi9kxz1b3lljd990az1x6c4jsiwcacrvimpib5c";
  })

  (fetchNuGet {
    name = "System.Reflection.Emit.Lightweight";
    version = "4.6.0";
    sha256 = "0hry2k6b7kicg4zxnq0hhn0ys52711pxy7l9v5sp7gvp9cicwpgp";
  })

  (fetchNuGet {
    name = "System.Reflection.Extensions";
    version = "4.0.1";
    sha256 = "0m7wqwq0zqq9gbpiqvgk3sr92cbrw7cp3xn53xvw7zj6rz6fdirn";
  })

  (fetchNuGet {
    name = "System.Reflection.Extensions";
    version = "4.3.0";
    sha256 = "02bly8bdc98gs22lqsfx9xicblszr2yan7v2mmw3g7hy6miq5hwq";
  })

  (fetchNuGet {
    name = "System.Reflection.Metadata";
    version = "1.6.0";
    sha256 = "1wdbavrrkajy7qbdblpbpbalbdl48q3h34cchz24gvdgyrlf15r4";
  })

  (fetchNuGet {
    name = "System.Reflection.Primitives";
    version = "4.0.1";
    sha256 = "1bangaabhsl4k9fg8khn83wm6yial8ik1sza7401621jc6jrym28";
  })

  (fetchNuGet {
    name = "System.Reflection.Primitives";
    version = "4.3.0";
    sha256 = "04xqa33bld78yv5r93a8n76shvc8wwcdgr1qvvjh959g3rc31276";
  })

  (fetchNuGet {
    name = "System.Reflection.TypeExtensions";
    version = "4.1.0";
    sha256 = "1bjli8a7sc7jlxqgcagl9nh8axzfl11f4ld3rjqsyxc516iijij7";
  })

  (fetchNuGet {
    name = "System.Reflection.TypeExtensions";
    version = "4.3.0";
    sha256 = "0y2ssg08d817p0vdag98vn238gyrrynjdj4181hdg780sif3ykp1";
  })

  (fetchNuGet {
    name = "System.Resources.ResourceManager";
    version = "4.0.1";
    sha256 = "0b4i7mncaf8cnai85jv3wnw6hps140cxz8vylv2bik6wyzgvz7bi";
  })

  (fetchNuGet {
    name = "System.Resources.ResourceManager";
    version = "4.3.0";
    sha256 = "0sjqlzsryb0mg4y4xzf35xi523s4is4hz9q4qgdvlvgivl7qxn49";
  })

  (fetchNuGet {
    name = "System.Runtime";
    version = "4.1.0";
    sha256 = "02hdkgk13rvsd6r9yafbwzss8kr55wnj8d5c7xjnp8gqrwc8sn0m";
  })

  (fetchNuGet {
    name = "System.Runtime";
    version = "4.3.0";
    sha256 = "066ixvgbf2c929kgknshcxqj6539ax7b9m570cp8n179cpfkapz7";
  })

  (fetchNuGet {
    name = "System.Runtime.CompilerServices.Unsafe";
    version = "4.5.2";
    sha256 = "1vz4275fjij8inf31np78hw50al8nqkngk04p3xv5n4fcmf1grgi";
  })

  (fetchNuGet {
    name = "System.Runtime.CompilerServices.Unsafe";
    version = "4.6.0";
    sha256 = "0xmzi2gpbmgyfr75p24rqqsba3cmrqgmcv45lsqp5amgrdwd0f0m";
  })

  (fetchNuGet {
    name = "System.Runtime.Extensions";
    version = "4.1.0";
    sha256 = "0rw4rm4vsm3h3szxp9iijc3ksyviwsv6f63dng3vhqyg4vjdkc2z";
  })

  (fetchNuGet {
    name = "System.Runtime.Extensions";
    version = "4.3.0";
    sha256 = "1ykp3dnhwvm48nap8q23893hagf665k0kn3cbgsqpwzbijdcgc60";
  })

  (fetchNuGet {
    name = "System.Runtime.Handles";
    version = "4.3.0";
    sha256 = "0sw2gfj2xr7sw9qjn0j3l9yw07x73lcs97p8xfc9w1x9h5g5m7i8";
  })

  (fetchNuGet {
    name = "System.Runtime.InteropServices";
    version = "4.1.0";
    sha256 = "01kxqppx3dr3b6b286xafqilv4s2n0gqvfgzfd4z943ga9i81is1";
  })

  (fetchNuGet {
    name = "System.Runtime.InteropServices";
    version = "4.3.0";
    sha256 = "00hywrn4g7hva1b2qri2s6rabzwgxnbpw9zfxmz28z09cpwwgh7j";
  })

  (fetchNuGet {
    name = "System.Runtime.InteropServices.RuntimeInformation";
    version = "4.3.0";
    sha256 = "0q18r1sh4vn7bvqgd6dmqlw5v28flbpj349mkdish2vjyvmnb2ii";
  })

  (fetchNuGet {
    name = "System.Runtime.Numerics";
    version = "4.3.0";
    sha256 = "19rav39sr5dky7afygh309qamqqmi9kcwvz3i0c5700v0c5cg61z";
  })

  (fetchNuGet {
    name = "System.Runtime.Serialization.Primitives";
    version = "4.1.1";
    sha256 = "042rfjixknlr6r10vx2pgf56yming8lkjikamg3g4v29ikk78h7k";
  })

  (fetchNuGet {
    name = "System.Security.AccessControl";
    version = "4.5.0";
    sha256 = "1wvwanz33fzzbnd2jalar0p0z3x0ba53vzx1kazlskp7pwyhlnq0";
  })

  (fetchNuGet {
    name = "System.Security.AccessControl";
    version = "4.7.0";
    sha256 = "0n0k0w44flkd8j0xw7g3g3vhw7dijfm51f75xkm1qxnbh4y45mpz";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Algorithms";
    version = "4.3.0";
    sha256 = "03sq183pfl5kp7gkvq77myv7kbpdnq3y0xj7vi4q1kaw54sny0ml";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Cng";
    version = "4.3.0";
    sha256 = "1k468aswafdgf56ab6yrn7649kfqx2wm9aslywjam1hdmk5yypmv";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Csp";
    version = "4.3.0";
    sha256 = "1x5wcrddf2s3hb8j78cry7yalca4lb5vfnkrysagbn6r9x6xvrx1";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Encoding";
    version = "4.3.0";
    sha256 = "1jr6w70igqn07k5zs1ph6xja97hxnb3mqbspdrff6cvssgrixs32";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.OpenSsl";
    version = "4.3.0";
    sha256 = "0givpvvj8yc7gv4lhb6s1prq6p2c4147204a0wib89inqzd87gqc";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.Primitives";
    version = "4.3.0";
    sha256 = "0pyzncsv48zwly3lw4f2dayqswcfvdwq2nz0dgwmi7fj3pn64wby";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.ProtectedData";
    version = "4.4.0";
    sha256 = "1q8ljvqhasyynp94a1d7jknk946m20lkwy2c3wa8zw2pc517fbj6";
  })

  (fetchNuGet {
    name = "System.Security.Cryptography.X509Certificates";
    version = "4.3.0";
    sha256 = "0valjcz5wksbvijylxijjxb1mp38mdhv03r533vnx1q3ikzdav9h";
  })

  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.3.0";
    sha256 = "00a0a7c40i3v4cb20s2cmh9csb5jv2l0frvnlzyfxh848xalpdwr";
  })

  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.5.0";
    sha256 = "0rmj89wsl5yzwh0kqjgx45vzf694v9p92r4x4q6yxldk1cv1hi86";
  })

  (fetchNuGet {
    name = "System.Security.Principal.Windows";
    version = "4.7.0";
    sha256 = "1a56ls5a9sr3ya0nr086sdpa9qv0abv31dd6fp27maqa9zclqq5d";
  })

  (fetchNuGet {
    name = "System.Text.Encoding";
    version = "4.0.11";
    sha256 = "1dyqv0hijg265dwxg6l7aiv74102d6xjiwplh2ar1ly6xfaa4iiw";
  })

  (fetchNuGet {
    name = "System.Text.Encoding";
    version = "4.3.0";
    sha256 = "1f04lkir4iladpp51sdgmis9dj4y8v08cka0mbmsy0frc9a4gjqr";
  })

  (fetchNuGet {
    name = "System.Text.Encoding.Extensions";
    version = "4.0.11";
    sha256 = "08nsfrpiwsg9x5ml4xyl3zyvjfdi4mvbqf93kjdh11j4fwkznizs";
  })

  (fetchNuGet {
    name = "System.Text.Encoding.Extensions";
    version = "4.3.0";
    sha256 = "11q1y8hh5hrp5a3kw25cb6l00v5l5dvirkz8jr3sq00h1xgcgrxy";
  })

  (fetchNuGet {
    name = "System.Text.RegularExpressions";
    version = "4.1.0";
    sha256 = "1mw7vfkkyd04yn2fbhm38msk7dz2xwvib14ygjsb8dq2lcvr18y7";
  })

  (fetchNuGet {
    name = "System.Text.RegularExpressions";
    version = "4.3.0";
    sha256 = "1bgq51k7fwld0njylfn7qc5fmwrk2137gdq7djqdsw347paa9c2l";
  })

  (fetchNuGet {
    name = "System.Threading";
    version = "4.0.11";
    sha256 = "19x946h926bzvbsgj28csn46gak2crv2skpwsx80hbgazmkgb1ls";
  })

  (fetchNuGet {
    name = "System.Threading";
    version = "4.3.0";
    sha256 = "0rw9wfamvhayp5zh3j7p1yfmx9b5khbf4q50d8k5rk993rskfd34";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks";
    version = "4.0.11";
    sha256 = "0nr1r41rak82qfa5m0lhk9mp0k93bvfd7bbd9sdzwx9mb36g28p5";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks";
    version = "4.3.0";
    sha256 = "134z3v9abw3a6jsw17xl3f6hqjpak5l682k2vz39spj4kmydg6k7";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks.Dataflow";
    version = "4.9.0";
    sha256 = "1g6s9pjg4z8iy98df60y9a01imdqy59zd767vz74rrng78jl2dk5";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.3.0";
    sha256 = "1xxcx2xh8jin360yjwm4x4cf5y3a2bwpn2ygkfkwkicz7zk50s2z";
  })

  (fetchNuGet {
    name = "System.Threading.Tasks.Extensions";
    version = "4.5.3";
    sha256 = "0g7r6hm572ax8v28axrdxz1gnsblg6kszq17g51pj14a5rn2af7i";
  })

  (fetchNuGet {
    name = "System.Threading.ThreadPool";
    version = "4.3.0";
    sha256 = "027s1f4sbx0y1xqw2irqn6x161lzj8qwvnh2gn78ciiczdv10vf1";
  })

  (fetchNuGet {
    name = "System.Threading.Timer";
    version = "4.3.0";
    sha256 = "1nx773nsx6z5whv8kaa1wjh037id2f1cxhb69pvgv12hd2b6qs56";
  })

  (fetchNuGet {
    name = "System.ValueTuple";
    version = "4.5.0";
    sha256 = "00k8ja51d0f9wrq4vv5z2jhq8hy31kac2rg0rv06prylcybzl8cy";
  })

  (fetchNuGet {
    name = "System.Xml.ReaderWriter";
    version = "4.0.11";
    sha256 = "0c6ky1jk5ada9m94wcadih98l6k1fvf6vi7vhn1msjixaha419l5";
  })

  (fetchNuGet {
    name = "System.Xml.ReaderWriter";
    version = "4.3.0";
    sha256 = "0c47yllxifzmh8gq6rq6l36zzvw4kjvlszkqa9wq3fr59n0hl3s1";
  })

  (fetchNuGet {
    name = "System.Xml.XDocument";
    version = "4.0.11";
    sha256 = "0n4lvpqzy9kc7qy1a4acwwd7b7pnvygv895az5640idl2y9zbz18";
  })

  (fetchNuGet {
    name = "System.Xml.XDocument";
    version = "4.3.0";
    sha256 = "08h8fm4l77n0nd4i4fk2386y809bfbwqb7ih9d7564ifcxr5ssxd";
  })

  (fetchNuGet {
    name = "System.Xml.XmlDocument";
    version = "4.3.0";
    sha256 = "0bmz1l06dihx52jxjr22dyv5mxv6pj4852lx68grjm7bivhrbfwi";
  })

]
