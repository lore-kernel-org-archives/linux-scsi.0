From: Matthew Thode <prometheanfire@gentoo.org>
Subject: mpt2sas driver barfs when force removing a drive on 3.13.1
Date: Fri, 31 Jan 2014 20:49:39 -0600
Message-ID: <52EC60C3.1080103@gentoo.org>
Reply-To: prometheanfire@gentoo.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="6coLEH5iGEt3i1KiFe4W2LINGcmx6trN8"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, JBottomley@parallels.com, linux-kernel@vger.kernel.org, kernel@gentoo.org
List-Id: linux-scsi@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--6coLEH5iGEt3i1KiFe4W2LINGcmx6trN8
Content-Type: multipart/mixed;
 boundary="------------090509050207080408060502"

This is a multi-part message in MIME format.
--------------090509050207080408060502
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

I decided to pull a drive while it was in use out of laziness (it was
open via luks, but not in actual use).  Got a fun trace as a result.
Just thought you'd like to know :D

The trace is attached

--=20
-- Matthew Thode (prometheanfire)

--------------090509050207080408060502
Content-Type: text/plain; charset=UTF-8;
 name="mpt2sas.trace"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="mpt2sas.trace"

[   11.727369] usbcore: registered new interface driver usbserial_generic=

[   11.752407] usbserial: USB Serial support registered for generic
[   11.777968] i8042: PNP: PS/2 Controller [PNP0303:PS2K,PNP0f03:PS2M] at=
 0x60,0x64 irq 1,12
[   11.807595] serio: i8042 KBD port at 0x60,0x64 irq 1
[   11.832740] serio: i8042 AUX port at 0x60,0x64 irq 12
[   11.857435] mousedev: PS/2 mouse device common for all mice
[   11.885136] input: PC Speaker as /devices/platform/pcspkr/input/input1=

[   11.935056] I2O subsystem v1.325
[   11.952094] input: AT Translated Set 2 keyboard as /devices/platform/i=
8042/serio0/input/input0
[   11.988309] i2o: max drivers =3D 8
[   12.012358] rtc_cmos 00:02: RTC can wake from S4
[   12.037228] rtc_cmos 00:02: rtc core: registered rtc_cmos as rtc0
[   12.064298] rtc_cmos 00:02: alarms up to one month, y3k, 114 bytes nvr=
am, hpet irqs
[   12.095839] md: linear personality registered for level -1
[   12.136141] md: raid0 personality registered for level 0
[   12.163061] md: raid1 personality registered for level 1
[   12.188570] md: raid10 personality registered for level 10
[   12.215463] md: raid6 personality registered for level 6
[   12.241582] md: raid5 personality registered for level 5
[   12.267540] md: raid4 personality registered for level 4
[   12.293007] md: multipath personality registered for level -4
[   12.318704] md: faulty personality registered for level -5
[   12.326869] psmouse serio1: alps: Unknown ALPS touchpad: E7=3D00 00 64=
, EC=3D00 00 64
[   12.375744] device-mapper: uevent: version 1.0.3
[   12.410329] mpt2sas0: expander_add: handle(0x0009), parent(0x0001), sa=
s_addr(0x5003048001c1ff7f), phys(30)
[   12.453925] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialise=
d: dm-devel@redhat.com
[   12.484580] device-mapper: multipath: version 1.6.0 loaded
[   12.512472] device-mapper: multipath round-robin: version 1.0.0 loaded=

[   12.540678] device-mapper: raid: Loading target version 1.5.2
[   12.568434] device-mapper: cache-policy-mq: version 1.1.0 loaded
[   12.596481] device-mapper: cache cleaner: version 1.0.0 loaded
[   12.625033] No iBFT detected.
[   12.654694] hidraw: raw HID events driver (C) Jiri Kosina
[   12.701949] input: American Megatrends Inc. Virtual Keyboard and Mouse=
 as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.0/input/input4
[   12.737335] hid-generic 0003:046B:FF10.0001: input,hidraw0: USB HID v1=
=2E10 Keyboard [American Megatrends Inc. Virtual Keyboard and Mouse] on u=
sb-0000:00:1a.2-2/input0
[   12.780957] input: American Megatrends Inc. Virtual Keyboard and Mouse=
 as /devices/pci0000:00/0000:00:1a.2/usb5/5-2/5-2:1.1/input/input5
[   12.818283] hid-generic 0003:046B:FF10.0002: input,hidraw1: USB HID v1=
=2E10 Mouse [American Megatrends Inc. Virtual Keyboard and Mouse] on usb-=
0000:00:1a.2-2/input1
[   12.859880] usbcore: registered new interface driver usbhid
[   12.891277] usbhid: USB HID core driver
[   12.925469] intel_rapl: driver does not support CPU family 6 model 44
[   12.978325] TCP: cubic registered
[   13.008157] NET: Registered protocol family 10
[   13.039192] mip6: Mobile IPv6
[   13.069200] ip6_gre: GRE over IPv6 tunneling driver
[   13.101959] NET: Registered protocol family 17
[   13.134071] 8021q: 802.1Q VLAN Support v1.8
[   13.168958] sctp: Hash tables configured (established 65536 bind 65536=
)
[   13.203422] Key type dns_resolver registered
[   13.235384] openvswitch: Open vSwitch switching datapath
[   13.273342] Loading compiled-in X.509 certificates
[   13.324794] Loaded X.509 cert 'Magrathea: Glacier signing key: 647ace3=
a40638d4bca23db831eb5ddffc3c66ee3'
[   13.362229] registered taskstats version 1
[   13.395128] console [netcon0] enabled
[   13.425968] netconsole: network logging started
[   13.457018] rtc_cmos 00:02: setting system clock to 2014-01-31 09:38:5=
5 UTC (1391161135)
[   13.493450] ALSA device list:
[   13.523413]   No soundcards found.
[   13.581167] input: ImExPS/2 Generic Explorer Mouse as /devices/platfor=
m/i8042/serio1/input/input3
[   14.617086] mpt2sas0: port enable: SUCCESS
[   14.686190] scsi 0:0:0:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   14.723035] scsi 0:0:0:0: SATA: handle(0x000a), sas_addr(0x5003048001c=
1ff6c), phy(12), device_name(0x5000cca22bcebba6)
[   14.763667] scsi 0:0:0:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(0)
[   14.823209] scsi 0:0:0:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   14.862662] scsi 0:0:0:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   14.905902] scsi 0:0:1:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   14.945628] scsi 0:0:1:0: SATA: handle(0x000b), sas_addr(0x5003048001c=
1ff6d), phy(13), device_name(0x5000cca22bce92fd)
[   14.988031] scsi 0:0:1:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(1)
[   15.027990] scsi 0:0:1:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   15.068985] scsi 0:0:1:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   15.117324] scsi 0:0:2:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   15.175997] scsi 0:0:2:0: SATA: handle(0x000c), sas_addr(0x5003048001c=
1ff6e), phy(14), device_name(0x5000cca22bcea24d)
[   15.219161] scsi 0:0:2:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(2)
[   15.259380] scsi 0:0:2:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   15.300134] scsi 0:0:2:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   15.345530] scsi 0:0:3:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   15.387808] scsi 0:0:3:0: SATA: handle(0x000d), sas_addr(0x5003048001c=
1ff6f), phy(15), device_name(0x5000cca22bcecd6a)
[   15.434548] scsi 0:0:3:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(3)
[   15.482749] scsi 0:0:3:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   15.549628] scsi 0:0:3:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   15.596698] scsi 0:0:4:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   15.636408] scsi 0:0:4:0: SATA: handle(0x000e), sas_addr(0x5003048001c=
1ff70), phy(16), device_name(0x5000cca22bcebab7)
[   15.679401] scsi 0:0:4:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(4)
[   15.718387] scsi 0:0:4:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   15.758728] scsi 0:0:4:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   15.802387] scsi 0:0:5:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   15.843763] scsi 0:0:5:0: SATA: handle(0x000f), sas_addr(0x5003048001c=
1ff71), phy(17), device_name(0x5000cca22bce48dc)
[   15.891484] scsi 0:0:5:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(5)
[   15.949805] scsi 0:0:5:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   15.991859] scsi 0:0:5:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   16.037487] scsi 0:0:6:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   16.080080] scsi 0:0:6:0: SATA: handle(0x0010), sas_addr(0x5003048001c=
1ff72), phy(18), device_name(0x5000cca22bcebeaa)
[   16.125588] scsi 0:0:6:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(6)
[   16.167976] scsi 0:0:6:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   16.211610] scsi 0:0:6:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   16.263838] scsi 0:0:7:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   16.324099] scsi 0:0:7:0: SATA: handle(0x0011), sas_addr(0x5003048001c=
1ff73), phy(19), device_name(0x5000cca22bce5c48)
[   16.370378] scsi 0:0:7:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(7)
[   16.413762] scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   16.457517] scsi 0:0:7:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   16.505669] scsi 0:0:8:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   16.550025] scsi 0:0:8:0: SATA: handle(0x0012), sas_addr(0x5003048001c=
1ff74), phy(20), device_name(0x5000cca22bcebbc3)
[   16.600555] scsi 0:0:8:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(8)
[   16.670141] scsi 0:0:8:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   16.715595] scsi 0:0:8:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   16.764129] scsi 0:0:9:0: Direct-Access     ATA      Hitachi HDS72404 =
A3B0 PQ: 0 ANSI: 6
[   16.808058] scsi 0:0:9:0: SATA: handle(0x0013), sas_addr(0x5003048001c=
1ff75), phy(21), device_name(0x5000cca22bcfffcb)
[   16.855865] scsi 0:0:9:0: SATA: enclosure_logical_id(0x5003048001c1ff7=
f), slot(9)
[   16.900230] scsi 0:0:9:0: atapi(n), ncq(y), asyn_notify(n), smart(y), =
fua(y), sw_preserve(y)
[   16.945676] scsi 0:0:9:0: qdepth(32), tagged(1), simple(0), ordered(0)=
, scsi_level(7), cmd_que(1)
[   16.996185] scsi 0:0:10:0: Direct-Access     ATA      HGST HDS724040AL=
 A580 PQ: 0 ANSI: 6
[   17.044298] scsi 0:0:10:0: SATA: handle(0x0014), sas_addr(0x5003048001=
c1ff76), phy(22), device_name(0x5000cca22bde5e1f)
[   17.109519] scsi 0:0:10:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(10)
[   17.154180] scsi 0:0:10:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   17.199940] scsi 0:0:10:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   17.248190] scsi 0:0:11:0: Direct-Access     ATA      HGST HDS724040AL=
 A580 PQ: 0 ANSI: 6
[   17.292313] scsi 0:0:11:0: SATA: handle(0x0015), sas_addr(0x5003048001=
c1ff77), phy(23), device_name(0x5000cca22bde9a4f)
[   17.340052] scsi 0:0:11:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(11)
[   17.386309] scsi 0:0:11:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   17.437477] scsi 0:0:11:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   17.505235] scsi 0:0:12:0: Direct-Access     ATA      Hitachi HDS72202=
 A3MA PQ: 0 ANSI: 6
[   17.550211] scsi 0:0:12:0: SATA: handle(0x0016), sas_addr(0x5003048001=
c1ff78), phy(24), device_name(0x5000cca222df662f)
[   17.599066] scsi 0:0:12:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(12)
[   17.642891] scsi 0:0:12:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   17.688288] scsi 0:0:12:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   17.737057] scsi 0:0:13:0: Direct-Access     ATA      Hitachi HDS72202=
 A3MA PQ: 0 ANSI: 6
[   17.782120] scsi 0:0:13:0: SATA: handle(0x0017), sas_addr(0x5003048001=
c1ff79), phy(25), device_name(0x5000cca222e1c62e)
[   17.834836] scsi 0:0:13:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(13)
[   17.894858] scsi 0:0:13:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   17.940459] scsi 0:0:13:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   17.989124] scsi 0:0:14:0: Direct-Access     ATA      Hitachi HDS72202=
 A20N PQ: 0 ANSI: 6
[   18.034250] scsi 0:0:14:0: SATA: handle(0x0018), sas_addr(0x5003048001=
c1ff7a), phy(26), device_name(0x5000cca221cb0597)
[   18.081482] scsi 0:0:14:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(14)
[   18.126142] scsi 0:0:14:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   18.171780] scsi 0:0:14:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   18.226521] scsi 0:0:15:0: Direct-Access     ATA      Hitachi HDS72202=
 A3EA PQ: 0 ANSI: 6
[   18.285076] scsi 0:0:15:0: SATA: handle(0x0019), sas_addr(0x5003048001=
c1ff7b), phy(27), device_name(0x5000cca221f7fa1b)
[   18.332196] scsi 0:0:15:0: SATA: enclosure_logical_id(0x5003048001c1ff=
7f), slot(15)
[   18.376908] scsi 0:0:15:0: atapi(n), ncq(y), asyn_notify(n), smart(y),=
 fua(y), sw_preserve(y)
[   18.422580] scsi 0:0:15:0: qdepth(32), tagged(1), simple(0), ordered(0=
), scsi_level(7), cmd_que(1)
[   18.470187] scsi 0:0:16:0: Enclosure         LSI CORP SAS2X28         =
 0717 PQ: 0 ANSI: 5
[   18.514412] scsi 0:0:16:0: SSP: handle(0x001a), sas_addr(0x5003048001c=
1ff7d), phy(28), device_name(0x5003048001c1ff7d)
[   18.562191] scsi 0:0:16:0: SSP: enclosure_logical_id(0x5003048001c1ff7=
f), slot(0)
[   18.612130] scsi 0:0:16:0: qdepth(254), tagged(1), simple(0), ordered(=
0), scsi_level(6), cmd_que(1)
[   18.687079] sd 0:0:0:0: Attached scsi generic sg0 type 0
[   18.728587] sd 0:0:1:0: Attached scsi generic sg1 type 0
[   18.769994] sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.770413] sd 0:0:2:0: Attached scsi generic sg2 type 0
[   18.770918] sd 0:0:3:0: Attached scsi generic sg3 type 0
[   18.771322] sd 0:0:1:0: [sdb] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.771324] sd 0:0:1:0: [sdb] 4096-byte physical blocks
[   18.771591] sd 0:0:4:0: Attached scsi generic sg4 type 0
[   18.771641] sd 0:0:2:0: [sdc] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.771643] sd 0:0:2:0: [sdc] 4096-byte physical blocks
[   18.772307] sd 0:0:3:0: [sdd] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.772308] sd 0:0:3:0: [sdd] 4096-byte physical blocks
[   18.772544] sd 0:0:5:0: Attached scsi generic sg5 type 0
[   18.772589] sd 0:0:4:0: [sde] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.772591] sd 0:0:4:0: [sde] 4096-byte physical blocks
[   18.773143] sd 0:0:6:0: Attached scsi generic sg6 type 0
[   18.773434] sd 0:0:7:0: Attached scsi generic sg7 type 0
[   18.774094] sd 0:0:5:0: [sdf] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.774096] sd 0:0:5:0: [sdf] 4096-byte physical blocks
[   18.774157] sd 0:0:8:0: Attached scsi generic sg8 type 0
[   18.774472] sd 0:0:6:0: [sdg] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.774473] sd 0:0:6:0: [sdg] 4096-byte physical blocks
[   18.774762] sd 0:0:7:0: [sdh] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.774764] sd 0:0:7:0: [sdh] 4096-byte physical blocks
[   18.775064] sd 0:0:8:0: [sdi] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.775065] sd 0:0:8:0: [sdi] 4096-byte physical blocks
[   18.775391] sd 0:0:9:0: Attached scsi generic sg9 type 0
[   18.776105] sd 0:0:10:0: Attached scsi generic sg10 type 0
[   18.776548] sd 0:0:9:0: [sdj] 7814037168 512-byte logical blocks: (4.0=
0 TB/3.63 TiB)
[   18.776565] sd 0:0:9:0: [sdj] 4096-byte physical blocks
[   18.776850] sd 0:0:11:0: Attached scsi generic sg11 type 0
[   18.777159] sd 0:0:12:0: Attached scsi generic sg12 type 0
[   18.777260] sd 0:0:10:0: [sdk] 7814037168 512-byte logical blocks: (4.=
00 TB/3.63 TiB)
[   18.777262] sd 0:0:10:0: [sdk] 4096-byte physical blocks
[   18.777802] sd 0:0:13:0: Attached scsi generic sg13 type 0
[   18.778285] sd 0:0:12:0: [sdm] 3907029168 512-byte logical blocks: (2.=
00 TB/1.81 TiB)
[   18.778364] sd 0:0:11:0: [sdl] 7814037168 512-byte logical blocks: (4.=
00 TB/3.63 TiB)
[   18.778366] sd 0:0:11:0: [sdl] 4096-byte physical blocks
[   18.778551] sd 0:0:14:0: Attached scsi generic sg14 type 0
[   18.778627] sd 0:0:13:0: [sdn] 3907029168 512-byte logical blocks: (2.=
00 TB/1.81 TiB)
[   18.778994] sd 0:0:15:0: Attached scsi generic sg15 type 0
[   18.779305] scsi 0:0:16:0: Attached scsi generic sg16 type 13
[   18.779650] sd 0:0:14:0: [sdo] 3907029168 512-byte logical blocks: (2.=
00 TB/1.81 TiB)
[   18.780153] sd 0:0:15:0: [sdp] 3907029168 512-byte logical blocks: (2.=
00 TB/1.81 TiB)
[   18.980985] sd 0:0:4:0: [sde] Write Protect is off
[   18.980987] sd 0:0:4:0: [sde] Mode Sense: 7f 00 10 08
[   18.983676] sd 0:0:4:0: [sde] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.984295] sd 0:0:7:0: [sdh] Write Protect is off
[   18.984297] sd 0:0:7:0: [sdh] Mode Sense: 7f 00 10 08
[   18.984827] sd 0:0:6:0: [sdg] Write Protect is off
[   18.984829] sd 0:0:6:0: [sdg] Mode Sense: 7f 00 10 08
[   18.986982] sd 0:0:7:0: [sdh] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.987222] sd 0:0:1:0: [sdb] Write Protect is off
[   18.987224] sd 0:0:1:0: [sdb] Mode Sense: 7f 00 10 08
[   18.987261] sd 0:0:5:0: [sdf] Write Protect is off
[   18.987263] sd 0:0:5:0: [sdf] Mode Sense: 7f 00 10 08
[   18.987584] sd 0:0:6:0: [sdg] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.989679] sd 0:0:8:0: [sdi] Write Protect is off
[   18.989681] sd 0:0:8:0: [sdi] Mode Sense: 7f 00 10 08
[   18.989943] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.990004] sd 0:0:5:0: [sdf] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.990867] sd 0:0:3:0: [sdd] Write Protect is off
[   18.990869] sd 0:0:3:0: [sdd] Mode Sense: 7f 00 10 08
[   18.992355] sd 0:0:8:0: [sdi] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.993565] sd 0:0:3:0: [sdd] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.994598] sd 0:0:2:0: [sdc] Write Protect is off
[   18.994600] sd 0:0:2:0: [sdc] Mode Sense: 7f 00 10 08
[   18.997271] sd 0:0:2:0: [sdc] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   18.999684] sd 0:0:10:0: [sdk] Write Protect is off
[   18.999686] sd 0:0:10:0: [sdk] Mode Sense: 7f 00 10 08
[   18.999743] sd 0:0:9:0: [sdj] Write Protect is off
[   18.999744] sd 0:0:9:0: [sdj] Mode Sense: 7f 00 10 08
[   19.001264] sd 0:0:11:0: [sdl] Write Protect is off
[   19.001266] sd 0:0:11:0: [sdl] Mode Sense: 7f 00 10 08
[   19.002398] sd 0:0:10:0: [sdk] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.002461] sd 0:0:9:0: [sdj] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   19.003952] sd 0:0:11:0: [sdl] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.041386] sd 0:0:14:0: [sdo] Write Protect is off
[   19.041388] sd 0:0:14:0: [sdo] Mode Sense: 7f 00 10 08
[   19.043700] sd 0:0:14:0: [sdo] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.061162] sd 0:0:13:0: [sdn] Write Protect is off
[   19.061164] sd 0:0:13:0: [sdn] Mode Sense: 7f 00 10 08
[   19.062839] sd 0:0:12:0: [sdm] Write Protect is off
[   19.062841] sd 0:0:12:0: [sdm] Mode Sense: 7f 00 10 08
[   19.063677] sd 0:0:13:0: [sdn] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.064179] sd 0:0:15:0: [sdp] Write Protect is off
[   19.064181] sd 0:0:15:0: [sdp] Mode Sense: 7f 00 10 08
[   19.065286] sd 0:0:12:0: [sdm] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.066620] sd 0:0:15:0: [sdp] Write cache: enabled, read cache: enabl=
ed, supports DPO and FUA
[   19.120727] ata2: SATA link down (SStatus 0 SControl 300)
[   19.241192] random: nonblocking pool is initialized
[   19.248687]  sde: sde1 sde2 sde3
[   19.249703]  sdd: sdd1 sdd2 sdd3
[   19.251568]  sdg: sdg1 sdg2 sdg3
[   19.253033]  sdb: sdb1 sdb2
[   19.255451]  sdf: sdf1 sdf2
[   19.257282]  sdi: sdi1 sdi2
[   19.260576]  sdc: sdc1 sdc2
[   19.261340]  sdh: sdh1 sdh2 sdh3
[   19.264249]  sdk: sdk1 sdk2 sdk3
[   19.266388]  sdl: sdl1 sdl2 sdl3
[   19.269777]  sdj: sdj1 sdj2 sdj3
[   19.341385]  sdo: sdo1 sdo2
[   19.371048]  sdn: sdn1 sdn2
[   19.374364]  sdm: sdm1 sdm2
[   19.380240]  sdp: sdp1 sdp2
[   19.470885] ata3: SATA link down (SStatus 0 SControl 300)
[   19.478323] sd 0:0:4:0: [sde] Attached SCSI disk
[   19.479866] sd 0:0:3:0: [sdd] Attached SCSI disk
[   19.482217] sd 0:0:6:0: [sdg] Attached SCSI disk
[   19.484575] sd 0:0:5:0: [sdf] Attached SCSI disk
[   19.484638] sd 0:0:1:0: [sdb] Attached SCSI disk
[   19.487053] sd 0:0:8:0: [sdi] Attached SCSI disk
[   19.490097] sd 0:0:7:0: [sdh] Attached SCSI disk
[   19.492026] sd 0:0:2:0: [sdc] Attached SCSI disk
[   19.496998] sd 0:0:10:0: [sdk] Attached SCSI disk
[   19.497121] sd 0:0:9:0: [sdj] Attached SCSI disk
[   19.498610] sd 0:0:11:0: [sdl] Attached SCSI disk
[   19.621365] sd 0:0:14:0: [sdo] Attached SCSI disk
[   19.666062] sd 0:0:13:0: [sdn] Attached SCSI disk
[   19.667677] sd 0:0:12:0: [sdm] Attached SCSI disk
[   19.677436] sd 0:0:15:0: [sdp] Attached SCSI disk
[   19.821244] ata4: SATA link down (SStatus 0 SControl 300)
[   20.171532] ata5: SATA link down (SStatus 0 SControl 300)
[   20.521738] ata6: SATA link down (SStatus 0 SControl 300)
[   22.040332] sd 0:0:0:0: [sda] 4096-byte physical blocks
[   22.265337] sd 0:0:0:0: [sda] Write Protect is off
[   22.297457] sd 0:0:0:0: [sda] Mode Sense: 7f 00 10 08
[   22.300134] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enable=
d, supports DPO and FUA
[   22.579595]  sda: sda1 sda2 sda3
[   22.837706] sd 0:0:0:0: [sda] Attached SCSI disk
[   22.867645] Freeing unused kernel memory: 1404K (ffffffff82130000 - ff=
ffffff8228f000)
[   22.891170] Write protecting the kernel read-only data: 16384k
[   22.907596] Freeing unused kernel memory: 44K (ffff8800019f5000 - ffff=
880001a00000)
[   22.928431] Freeing unused kernel memory: 860K (ffff880001f29000 - fff=
f880002000000)
[   23.299630] SPL: using hostid 0x00000000
[   31.013573] kjournald starting.  Commit interval 5 seconds
[   31.013592] EXT3-fs (sda1): mounted filesystem with ordered data mode
[   80.171569] bio: create slab <bio-1> at 1
[   80.305048] bio: create slab <bio-1> at 1
[  102.086561]  zd0: unknown partition table
[  106.372509] udevd[4477]: starting version 1.3
[  131.348840] IPv6: ADDRCONF(NETDEV_UP): eth1: link is not ready
[  131.348841] 8021q: adding VLAN 0 to HW filter on device eth1
[  131.562401] IPv6: ADDRCONF(NETDEV_UP): eth1.3: link is not ready
[  134.661726] e1000e: eth1 NIC Link is Up 1000 Mbps Full Duplex, Flow Co=
ntrol: Rx/Tx
[  134.662035] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
[  134.662291] IPv6: ADDRCONF(NETDEV_CHANGE): eth1.3: link becomes ready
[  146.831018] NFSD: Using /var/lib/nfs/v4recovery as the NFSv4 state rec=
overy directory
[  146.839677] NFSD: starting 90-second grace period (net ffffffff820e7a8=
0)
[ 2340.315713] perf samples too long (2505 > 2500), lowering kernel.perf_=
event_max_sample_rate to 50000
[55304.558011] sd 0:0:12:0: [sdm] Synchronizing SCSI cache
[55304.558060] sd 0:0:12:0: [sdm] =20
[55304.558062] Result: hostbyte=3D0x01 driverbyte=3D0x00
[55304.558233] ------------[ cut here ]------------
[55304.558239] WARNING: CPU: 1 PID: 30539 at fs/sysfs/group.c:214 sysfs_r=
emove_group+0x54/0xb2()
[55304.558241] sysfs group ffffffff820be910 not found for kobject 'end_de=
vice-0:0:12'
[55304.558242] Modules linked in:
[55304.558245] CPU: 1 PID: 30539 Comm: kworker/u32:1 Tainted: G          =
I  3.13.1 #3
[55304.558246] Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0        07/=
29/10 =20
[55304.558251] Workqueue: fw_event0 _firmware_event_work
[55304.558253]  0000000000000009 ffff880331657a08 ffffffff819e3afa 000000=
0000000006
[55304.558256]  ffff880331657a58 ffff880331657a48 ffffffff810dfa00 ffff88=
0331657a38
[55304.558259]  ffffffff812e9410 0000000000000000 ffffffff820be910 ffff88=
06006d3010
[55304.558262] Call Trace:
[55304.558267]  [<ffffffff819e3afa>] dump_stack+0x46/0x58
[55304.558272]  [<ffffffff810dfa00>] warn_slowpath_common+0x81/0x9b
[55304.558274]  [<ffffffff812e9410>] ? sysfs_remove_group+0x54/0xb2
[55304.558277]  [<ffffffff810dfabd>] warn_slowpath_fmt+0x46/0x48
[55304.558279]  [<ffffffff812e867c>] ? sysfs_get_dirent_ns+0x63/0x6d
[55304.558281]  [<ffffffff812e9410>] sysfs_remove_group+0x54/0xb2
[55304.558285]  [<ffffffff81648fe9>] dpm_sysfs_remove+0x3e/0x45
[55304.558289]  [<ffffffff81640e50>] device_del+0x44/0x181
[55304.558291]  [<ffffffff81640fd5>] device_unregister+0x48/0x54
[55304.558295]  [<ffffffff815319f9>] bsg_unregister_queue+0x5f/0x94
[55304.558299]  [<ffffffff816795ff>] sas_rphy_free+0xb2/0xcb
[55304.558302]  [<ffffffff81679633>] sas_rphy_delete+0x1b/0x1f
[55304.558304]  [<ffffffff81679661>] sas_port_delete+0x2a/0x11a
[55304.558307]  [<ffffffff819e9d45>] ? mutex_unlock+0xe/0x10
[55304.558310]  [<ffffffff816b40b3>] mpt2sas_transport_port_remove+0x165/=
0x186
[55304.558313]  [<ffffffff816aa191>] _scsih_remove_device+0x88/0xe2
[55304.558316]  [<ffffffff816abda4>] _scsih_device_remove_by_handle.part.=
33+0x7e/0x87
[55304.558318]  [<ffffffff816afa8b>] _firmware_event_work+0x7e7/0x16be
[55304.558323]  [<ffffffff81102f72>] ? finish_task_switch+0x5e/0xcc
[55304.558326]  [<ffffffff810e9ff2>] ? add_timer+0x1a/0x1c
[55304.558328]  [<ffffffff810f4af6>] ? __queue_delayed_work+0xef/0x10f
[55304.558331]  [<ffffffff810f5210>] process_one_work+0x1ec/0x379
[55304.558333]  [<ffffffff810f5806>] worker_thread+0x1d6/0x2d1
[55304.558335]  [<ffffffff810f5630>] ? rescuer_thread+0x264/0x264
[55304.558337]  [<ffffffff810faab3>] kthread+0xea/0xf2
[55304.558340]  [<ffffffff810fa9c9>] ? __init_kthread_worker+0x39/0x39
[55304.558342]  [<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[55304.558345]  [<ffffffff810fa9c9>] ? __init_kthread_worker+0x39/0x39
[55304.558346] ---[ end trace 7caf424b4d0de549 ]---
[55304.558503] mpt2sas0: removing handle(0x0016), sas_addr(0x5003048001c1=
ff78)
[55481.195626] ------------[ cut here ]------------
[55481.195633] WARNING: CPU: 3 PID: 411 at fs/sysfs/group.c:214 sysfs_rem=
ove_group+0x54/0xb2()
[55481.195634] sysfs group ffffffff820be910 not found for kobject 'target=
0:0:12'
[55481.195635] Modules linked in:
[55481.195638] CPU: 3 PID: 411 Comm: cryptsetup Tainted: G        W I  3.=
13.1 #3
[55481.195639] Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0        07/=
29/10 =20
[55481.195641]  0000000000000009 ffff8805fb295828 ffffffff819e3afa 000000=
0000000006
[55481.195644]  ffff8805fb295878 ffff8805fb295868 ffffffff810dfa00 ffffff=
ff820be990
[55481.195647]  ffffffff812e9410 0000000000000000 ffffffff820be910 ffff88=
06006d6c38
[55481.195650] Call Trace:
[55481.195655]  [<ffffffff819e3afa>] dump_stack+0x46/0x58
[55481.195660]  [<ffffffff810dfa00>] warn_slowpath_common+0x81/0x9b
[55481.195662]  [<ffffffff812e9410>] ? sysfs_remove_group+0x54/0xb2
[55481.195665]  [<ffffffff810dfabd>] warn_slowpath_fmt+0x46/0x48
[55481.195667]  [<ffffffff812e867c>] ? sysfs_get_dirent_ns+0x63/0x6d
[55481.195669]  [<ffffffff812e9410>] sysfs_remove_group+0x54/0xb2
[55481.195673]  [<ffffffff81648fe9>] dpm_sysfs_remove+0x3e/0x45
[55481.195677]  [<ffffffff81640e50>] device_del+0x44/0x181
[55481.195682]  [<ffffffff816621fc>] scsi_target_reap_usercontext+0x27/0x=
34
[55481.195685]  [<ffffffff810f46e0>] execute_in_process_context+0x24/0x5d=

[55481.195687]  [<ffffffff81662d0f>] scsi_target_reap+0xb3/0xbc
[55481.195689]  [<ffffffff816648e1>] scsi_device_dev_release_usercontext+=
0x178/0x1a6
[55481.195691]  [<ffffffff810f46e0>] execute_in_process_context+0x24/0x5d=

[55481.195693]  [<ffffffff81664767>] scsi_device_dev_release+0x1c/0x1e
[55481.195696]  [<ffffffff81640237>] device_release+0x5f/0x98
[55481.195699]  [<ffffffff8153a41a>] kobject_release+0x121/0x158
[55481.195701]  [<ffffffff8153a498>] kobject_put+0x47/0x4b
[55481.195704]  [<ffffffff8163ffea>] put_device+0x17/0x19
[55481.195706]  [<ffffffff8165a6f5>] scsi_device_put+0x43/0x48
[55481.195709]  [<ffffffff816e093c>] scsi_disk_put+0x30/0x41
[55481.195712]  [<ffffffff816e0fd2>] sd_release+0x4f/0x54
[55481.195715]  [<ffffffff812114a2>] __blkdev_put+0xae/0x155
[55481.195718]  [<ffffffff811f8e0b>] ? iput+0x136/0x13f
[55481.195720]  [<ffffffff8121153a>] __blkdev_put+0x146/0x155
[55481.195724]  [<ffffffff8182ff97>] ? __hash_remove+0xd0/0xd0
[55481.195726]  [<ffffffff8121165a>] blkdev_put+0x111/0x11a
[55481.195728]  [<ffffffff8182ce02>] close_dev+0x3a/0x47
[55481.195730]  [<ffffffff8182ce38>] dm_put_device+0x29/0x61
[55481.195732]  [<ffffffff81836f96>] crypt_dtr+0x102/0x135
[55481.195734]  [<ffffffff81836e94>] ? crypt_free_tfms+0x78/0x78
[55481.195737]  [<ffffffff8182d511>] dm_table_destroy+0x57/0xd1
[55481.195739]  [<ffffffff8182c687>] __dm_destroy+0x10e/0x208
[55481.195741]  [<ffffffff8182c7a6>] dm_destroy+0x13/0x15
[55481.195743]  [<ffffffff8183008c>] dev_remove+0xf5/0x101
[55481.195746]  [<ffffffff818305fe>] ctl_ioctl+0x3e9/0x411
[55481.195748]  [<ffffffff811864bf>] ? release_pages+0x1ad/0x1cd
[55481.195753]  [<ffffffff8114ba00>] ? audit_filter_rules.isra.3+0x77c/0x=
b49
[55481.195755]  [<ffffffff81830639>] dm_ctl_ioctl+0x13/0x17
[55481.195758]  [<ffffffff811f203f>] do_vfs_ioctl+0x413/0x45d
[55481.195760]  [<ffffffff8114be65>] ? audit_filter_syscall+0x98/0xcc
[55481.195762]  [<ffffffff811f20e0>] SyS_ioctl+0x57/0x87
[55481.195765]  [<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[55481.195766] ---[ end trace 7caf424b4d0de54a ]---
UID        PID  PPID  C STIME TTY          TIME CMD
root         1     0  0 Jan31 ?        00:00:08 init [3]  =20
root         2     0  0 Jan31 ?        00:00:00 [kthreadd]
root         3     2  0 Jan31 ?        00:03:17 [ksoftirqd/0]
root         5     2  0 Jan31 ?        00:00:00 [kworker/0:0H]
root         7     2  0 Jan31 ?        00:00:09 [rcu_sched]
root         8     2  0 Jan31 ?        00:00:00 [rcu_bh]
root         9     2  0 Jan31 ?        00:00:00 [migration/0]
root        10     2  0 Jan31 ?        00:00:00 [watchdog/0]
root        11     2  0 Jan31 ?        00:00:02 [watchdog/1]
root        12     2  0 Jan31 ?        00:00:00 [migration/1]
root        13     2  0 Jan31 ?        00:00:00 [ksoftirqd/1]
root        15     2  0 Jan31 ?        00:00:00 [kworker/1:0H]
root        16     2  0 Jan31 ?        00:00:02 [watchdog/2]
root        17     2  0 Jan31 ?        00:00:00 [migration/2]
root        18     2  0 Jan31 ?        00:00:00 [ksoftirqd/2]
root        20     2  0 Jan31 ?        00:00:00 [kworker/2:0H]
root        21     2  0 Jan31 ?        00:00:02 [watchdog/3]
root        22     2  0 Jan31 ?        00:00:00 [migration/3]
root        23     2  0 Jan31 ?        00:00:00 [ksoftirqd/3]
root        25     2  0 Jan31 ?        00:00:00 [kworker/3:0H]
root        26     2  0 Jan31 ?        00:00:00 [watchdog/4]
root        27     2  0 Jan31 ?        00:00:00 [migration/4]
root        28     2  0 Jan31 ?        00:00:00 [ksoftirqd/4]
root        30     2  0 Jan31 ?        00:00:00 [kworker/4:0H]
root        31     2  0 Jan31 ?        00:00:01 [watchdog/5]
root        32     2  0 Jan31 ?        00:00:00 [migration/5]
root        33     2  0 Jan31 ?        00:00:00 [ksoftirqd/5]
root        35     2  0 Jan31 ?        00:00:00 [kworker/5:0H]
root        36     2  0 Jan31 ?        00:00:01 [watchdog/6]
root        37     2  0 Jan31 ?        00:00:00 [migration/6]
root        38     2  0 Jan31 ?        00:00:00 [ksoftirqd/6]
root        40     2  0 Jan31 ?        00:00:00 [kworker/6:0H]
root        41     2  0 Jan31 ?        00:00:01 [watchdog/7]
root        42     2  0 Jan31 ?        00:00:00 [migration/7]
root        43     2  0 Jan31 ?        00:00:00 [ksoftirqd/7]
root        45     2  0 Jan31 ?        00:00:00 [kworker/7:0H]
root        46     2  0 Jan31 ?        00:00:00 [khelper]
root        47     2  0 Jan31 ?        00:00:00 [kdevtmpfs]
root        48     2  0 Jan31 ?        00:00:00 [netns]
root       542     2  0 Jan31 ?        00:00:00 [writeback]
root       544     2  0 Jan31 ?        00:00:00 [bioset]
root       546     2  0 Jan31 ?        00:00:00 [kblockd]
root       701     2  0 Jan31 ?        00:00:00 [khubd]
root       710     2  0 Jan31 ?        00:00:00 [md]
root       849     2  0 Jan31 ?        00:00:00 [rpciod]
root       851     2  0 Jan31 ?        00:00:00 [kvm-irqfd-clean]
root       932     2  0 Jan31 ?        00:00:00 [khungtaskd]
root       939     2  0 Jan31 ?        00:00:00 [kswapd0]
root       940     2  0 Jan31 ?        00:00:00 [ksmd]
root       941     2  0 Jan31 ?        00:00:00 [khugepaged]
root       942     2  0 Jan31 ?        00:00:01 [spl_kmem_cache/]
root       943     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       944     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       945     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       946     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       947     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       948     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       949     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       950     2  0 Jan31 ?        00:00:00 [spl_system_task]
root       953     2  0 Jan31 ?        00:00:06 [arc_adapt]
root       954     2  0 Jan31 ?        00:00:00 [l2arc_feed]
root       955     2  0 Jan31 ?        00:00:00 [z_unmount/0]
root       956     2  0 Jan31 ?        00:00:00 [zvol/0]
root       957     2  0 Jan31 ?        00:00:00 [zvol/1]
root       958     2  0 Jan31 ?        00:00:00 [zvol/2]
root       959     2  0 Jan31 ?        00:00:00 [zvol/3]
root       960     2  0 Jan31 ?        00:00:00 [zvol/4]
root       961     2  0 Jan31 ?        00:00:00 [zvol/5]
root       962     2  0 Jan31 ?        00:00:00 [zvol/6]
root       963     2  0 Jan31 ?        00:00:00 [zvol/7]
root       964     2  0 Jan31 ?        00:00:00 [zvol/8]
root       965     2  0 Jan31 ?        00:00:00 [zvol/9]
root       966     2  0 Jan31 ?        00:00:00 [zvol/10]
root       967     2  0 Jan31 ?        00:00:00 [zvol/11]
root       968     2  0 Jan31 ?        00:00:00 [zvol/12]
root       969     2  0 Jan31 ?        00:00:00 [zvol/13]
root       970     2  0 Jan31 ?        00:00:00 [zvol/14]
root       971     2  0 Jan31 ?        00:00:00 [zvol/15]
root       972     2  0 Jan31 ?        00:00:00 [zvol/16]
root       973     2  0 Jan31 ?        00:00:00 [zvol/17]
root       974     2  0 Jan31 ?        00:00:00 [zvol/18]
root       975     2  0 Jan31 ?        00:00:00 [zvol/19]
root       976     2  0 Jan31 ?        00:00:00 [zvol/20]
root       977     2  0 Jan31 ?        00:00:00 [zvol/21]
root       978     2  0 Jan31 ?        00:00:00 [zvol/22]
root       979     2  0 Jan31 ?        00:00:00 [zvol/23]
root       980     2  0 Jan31 ?        00:00:00 [zvol/24]
root       981     2  0 Jan31 ?        00:00:00 [zvol/25]
root       982     2  0 Jan31 ?        00:00:00 [zvol/26]
root       983     2  0 Jan31 ?        00:00:00 [zvol/27]
root       984     2  0 Jan31 ?        00:00:00 [zvol/28]
root       985     2  0 Jan31 ?        00:00:00 [zvol/29]
root       986     2  0 Jan31 ?        00:00:00 [zvol/30]
root       987     2  0 Jan31 ?        00:00:00 [zvol/31]
root       991     2  0 Jan31 ?        00:00:00 [fsnotify_mark]
root       995     2  0 Jan31 ?        00:00:00 [nfsiod]
root       996     2  0 Jan31 ?        00:00:00 [cifsiod]
root       999     2  0 Jan31 ?        00:00:00 [xfsalloc]
root      1000     2  0 Jan31 ?        00:00:00 [xfs_mru_cache]
root      1001     2  0 Jan31 ?        00:00:00 [xfslogd]
root      1002     2  0 Jan31 ?        00:00:00 [crypto]
root      1079     2  0 Jan31 ?        00:01:55 [kipmi0]
root      1120     2  0 Jan31 ?        00:00:00 [ttm_swap]
root      1199     2  0 Jan31 ?        00:00:00 [iscsi_eh]
root      1214     2  0 Jan31 ?        00:00:00 [scsi_eh_0]
root      1219     2  0 Jan31 ?        00:00:00 [fw_event0]
root      1254     2  0 Jan31 ?        00:00:00 [scsi_eh_1]
root      1257     2  0 Jan31 ?        00:00:00 [scsi_eh_2]
root      1260     2  0 Jan31 ?        00:00:00 [scsi_eh_3]
root      1263     2  0 Jan31 ?        00:00:00 [scsi_eh_4]
root      1266     2  0 Jan31 ?        00:00:00 [scsi_eh_5]
root      1269     2  0 Jan31 ?        00:00:00 [scsi_eh_6]
root      1279     2  0 Jan31 ?        00:00:00 [bond0]
root      1348     2  0 Jan31 ?        00:00:00 [vfio-irqfd-clea]
root      1415     2  0 Jan31 ?        00:00:00 [kpsmoused]
root      1424     2  0 Jan31 ?        00:00:00 [exec-osm]
root      1430     2  0 Jan31 ?        00:00:00 [raid5wq]
root      1431     2  0 Jan31 ?        00:00:00 [bcache]
root      1432     2  0 Jan31 ?        00:00:00 [bch_btree_io]
root      1468     2  0 Jan31 ?        00:00:00 [dm_bufio_cache]
root      1469     2  0 Jan31 ?        00:00:00 [kmpathd]
root      1470     2  0 Jan31 ?        00:00:00 [kmpath_handlerd]
root      1539     2  0 Jan31 ?        00:00:00 [deferwq]
root      1611     2  0 Jan31 ?        00:00:00 [poll_0_status]
root      3496     2  0 Jan31 ?        00:03:58 [kworker/0:1H]
root      3594     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3595     2  0 Jan31 ?        00:00:00 [bioset]
root      3596     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3597     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3598     2  0 Jan31 ?        00:00:00 [bioset]
root      3617     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3618     2  0 Jan31 ?        00:00:00 [bioset]
root      3619     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3620     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3621     2  0 Jan31 ?        00:00:00 [bioset]
root      3640     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3641     2  0 Jan31 ?        00:00:00 [bioset]
root      3642     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3643     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3644     2  0 Jan31 ?        00:00:00 [bioset]
root      3663     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3664     2  0 Jan31 ?        00:00:00 [bioset]
root      3665     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3666     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3667     2  0 Jan31 ?        00:00:00 [bioset]
root      3686     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3687     2  0 Jan31 ?        00:00:00 [bioset]
root      3688     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3689     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3690     2  0 Jan31 ?        00:00:00 [bioset]
root      3709     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3710     2  0 Jan31 ?        00:00:00 [bioset]
root      3711     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3712     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3713     2  0 Jan31 ?        00:00:00 [bioset]
root      3732     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3733     2  0 Jan31 ?        00:00:00 [bioset]
root      3734     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3735     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3736     2  0 Jan31 ?        00:00:00 [bioset]
root      3755     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3756     2  0 Jan31 ?        00:00:00 [bioset]
root      3757     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3758     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3759     2  0 Jan31 ?        00:00:00 [bioset]
root      3778     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3779     2  0 Jan31 ?        00:00:00 [bioset]
root      3780     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3781     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3782     2  0 Jan31 ?        00:00:00 [bioset]
root      3802     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3803     2  0 Jan31 ?        00:00:00 [bioset]
root      3804     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3805     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3806     2  0 Jan31 ?        00:00:00 [bioset]
root      3825     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3826     2  0 Jan31 ?        00:00:00 [bioset]
root      3827     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3828     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3829     2  0 Jan31 ?        00:00:00 [bioset]
root      3848     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3849     2  0 Jan31 ?        00:00:00 [bioset]
root      3850     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3851     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3852     2  0 Jan31 ?        00:00:00 [bioset]
root      3871     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3872     2  0 Jan31 ?        00:00:00 [bioset]
root      3873     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3874     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3875     2  0 Jan31 ?        00:00:00 [bioset]
root      3894     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3895     2  0 Jan31 ?        00:00:00 [bioset]
root      3896     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3897     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3898     2  0 Jan31 ?        00:00:00 [bioset]
root      3917     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3918     2  0 Jan31 ?        00:00:00 [bioset]
root      3919     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3920     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3921     2  0 Jan31 ?        00:00:00 [bioset]
root      3941     2  0 Jan31 ?        00:00:00 [kdmflush]
root      3942     2  0 Jan31 ?        00:00:00 [bioset]
root      3943     2  0 Jan31 ?        00:00:00 [kcryptd_io]
root      3944     2  0 Jan31 ?        00:00:00 [kcryptd]
root      3945     2  0 Jan31 ?        00:00:00 [bioset]
root      4166     2  0 Jan31 ?        00:00:05 [z_null_iss/0]
root      4167     2  0 Jan31 ?        00:00:01 [z_null_int/0]
root      4168     2  1 Jan31 ?        00:14:51 [z_rd_iss/0]
root      4169     2  1 Jan31 ?        00:14:50 [z_rd_iss/1]
root      4170     2  1 Jan31 ?        00:14:51 [z_rd_iss/2]
root      4171     2  1 Jan31 ?        00:14:50 [z_rd_iss/3]
root      4172     2  1 Jan31 ?        00:14:50 [z_rd_iss/4]
root      4173     2  1 Jan31 ?        00:14:50 [z_rd_iss/5]
root      4174     2  1 Jan31 ?        00:14:50 [z_rd_iss/6]
root      4175     2  1 Jan31 ?        00:14:50 [z_rd_iss/7]
root      4176     2 12 Jan31 ?        01:58:48 [z_rd_int/0]
root      4177     2 12 Jan31 ?        01:58:49 [z_rd_int/1]
root      4178     2 12 Jan31 ?        01:58:55 [z_rd_int/2]
root      4179     2 12 Jan31 ?        01:58:52 [z_rd_int/3]
root      4180     2 12 Jan31 ?        01:58:48 [z_rd_int/4]
root      4181     2 12 Jan31 ?        01:58:54 [z_rd_int/5]
root      4182     2  0 Jan31 ?        00:00:47 [z_wr_iss/0]
root      4183     2  0 Jan31 ?        00:00:46 [z_wr_iss/1]
root      4184     2  0 Jan31 ?        00:00:46 [z_wr_iss/2]
root      4185     2  0 Jan31 ?        00:00:47 [z_wr_iss/3]
root      4186     2  0 Jan31 ?        00:00:47 [z_wr_iss/4]
root      4187     2  0 Jan31 ?        00:00:47 [z_wr_iss/5]
root      4188     2  0 Jan31 ?        00:00:00 [z_wr_iss_h/0]
root      4189     2  0 Jan31 ?        00:00:00 [z_wr_iss_h/1]
root      4190     2  0 Jan31 ?        00:00:00 [z_wr_iss_h/2]
root      4191     2  0 Jan31 ?        00:00:00 [z_wr_iss_h/3]
root      4192     2  0 Jan31 ?        00:00:00 [z_wr_iss_h/4]
root      4193     2  0 Jan31 ?        00:00:09 [z_wr_int/0]
root      4194     2  0 Jan31 ?        00:00:09 [z_wr_int/1]
root      4195     2  0 Jan31 ?        00:00:09 [z_wr_int/2]
root      4196     2  0 Jan31 ?        00:00:09 [z_wr_int/3]
root      4197     2  0 Jan31 ?        00:00:09 [z_wr_int/4]
root      4198     2  0 Jan31 ?        00:00:09 [z_wr_int/5]
root      4199     2  0 Jan31 ?        00:00:09 [z_wr_int/6]
root      4200     2  0 Jan31 ?        00:00:09 [z_wr_int/7]
root      4201     2  0 Jan31 ?        00:00:09 [z_wr_int/8]
root      4202     2  0 Jan31 ?        00:00:09 [z_wr_int/9]
root      4203     2  0 Jan31 ?        00:00:09 [z_wr_int/10]
root      4204     2  0 Jan31 ?        00:00:09 [z_wr_int/11]
root      4205     2  0 Jan31 ?        00:00:09 [z_wr_int/12]
root      4206     2  0 Jan31 ?        00:00:09 [z_wr_int/13]
root      4207     2  0 Jan31 ?        00:00:09 [z_wr_int/14]
root      4208     2  0 Jan31 ?        00:00:09 [z_wr_int/15]
root      4209     2  0 Jan31 ?        00:00:00 [z_wr_int_h/0]
root      4210     2  0 Jan31 ?        00:00:00 [z_wr_int_h/1]
root      4211     2  0 Jan31 ?        00:00:00 [z_wr_int_h/2]
root      4212     2  0 Jan31 ?        00:00:00 [z_wr_int_h/3]
root      4213     2  0 Jan31 ?        00:00:00 [z_wr_int_h/4]
root      4214     2  0 Jan31 ?        00:00:00 [z_fr_iss_0/0]
root      4215     2  0 Jan31 ?        00:00:00 [z_fr_iss_0/1]
root      4216     2  0 Jan31 ?        00:00:00 [z_fr_iss_0/2]
root      4217     2  0 Jan31 ?        00:00:00 [z_fr_iss_0/3]
root      4218     2  0 Jan31 ?        00:00:00 [z_fr_iss_1/0]
root      4219     2  0 Jan31 ?        00:00:00 [z_fr_iss_1/1]
root      4220     2  0 Jan31 ?        00:00:00 [z_fr_iss_1/2]
root      4221     2  0 Jan31 ?        00:00:00 [z_fr_iss_1/3]
root      4222     2  0 Jan31 ?        00:00:00 [z_fr_iss_2/0]
root      4223     2  0 Jan31 ?        00:00:00 [z_fr_iss_2/1]
root      4224     2  0 Jan31 ?        00:00:00 [z_fr_iss_2/2]
root      4225     2  0 Jan31 ?        00:00:00 [z_fr_iss_2/3]
root      4226     2  0 Jan31 ?        00:00:00 [z_fr_iss_3/0]
root      4227     2  0 Jan31 ?        00:00:00 [z_fr_iss_3/1]
root      4228     2  0 Jan31 ?        00:00:00 [z_fr_iss_3/2]
root      4229     2  0 Jan31 ?        00:00:00 [z_fr_iss_3/3]
root      4230     2  0 Jan31 ?        00:00:00 [z_fr_iss_4/0]
root      4231     2  0 Jan31 ?        00:00:00 [z_fr_iss_4/1]
root      4232     2  0 Jan31 ?        00:00:00 [z_fr_iss_4/2]
root      4233     2  0 Jan31 ?        00:00:00 [z_fr_iss_4/3]
root      4234     2  0 Jan31 ?        00:00:00 [z_fr_iss_5/0]
root      4235     2  0 Jan31 ?        00:00:00 [z_fr_iss_5/1]
root      4236     2  0 Jan31 ?        00:00:00 [z_fr_iss_5/2]
root      4237     2  0 Jan31 ?        00:00:00 [z_fr_iss_5/3]
root      4238     2  0 Jan31 ?        00:00:00 [z_fr_iss_6/0]
root      4239     2  0 Jan31 ?        00:00:00 [z_fr_iss_6/1]
root      4240     2  0 Jan31 ?        00:00:00 [z_fr_iss_6/2]
root      4241     2  0 Jan31 ?        00:00:00 [z_fr_iss_6/3]
root      4242     2  0 Jan31 ?        00:00:00 [z_fr_iss_7/0]
root      4243     2  0 Jan31 ?        00:00:00 [z_fr_iss_7/1]
root      4244     2  0 Jan31 ?        00:00:00 [z_fr_iss_7/2]
root      4245     2  0 Jan31 ?        00:00:00 [z_fr_iss_7/3]
root      4246     2  0 Jan31 ?        00:00:00 [z_fr_int/0]
root      4247     2  0 Jan31 ?        00:00:00 [z_cl_iss/0]
root      4248     2  0 Jan31 ?        00:00:00 [z_cl_int/0]
root      4249     2  0 Jan31 ?        00:00:01 [z_ioctl_iss/0]
root      4250     2  0 Jan31 ?        00:00:01 [z_ioctl_int/0]
root      4267     2  0 Jan31 ?        00:00:00 [zfs_iput_taskq/]
root      4272     2  0 Jan31 ?        00:00:00 [kworker/7:1H]
root      4279     2  0 Jan31 ?        00:00:00 [txg_quiesce]
root      4280     2  1 Jan31 ?        00:17:14 [txg_sync]
root      4295     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4311     2  0 Jan31 ?        00:00:00 [kworker/3:1H]
root      4477     1  0 Jan31 ?        00:00:00 /sbin/udevd --daemon
root      4769     2  0 Jan31 ?        00:00:00 [kworker/4:1H]
root      4936     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4939     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4942     2  0 Jan31 ?        00:00:02 [zil_clean/0]
root      4946     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4949     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4952     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4955     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4958     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      4962     2  0 Jan31 ?        00:00:00 [zil_clean/0]
root      5165     2  0 Jan31 ?        00:00:00 [kworker/2:1H]
root      5449     1  0 Jan31 ?        00:00:00 /sbin/auditd
root      5452     2  0 Jan31 ?        00:00:00 [kauditd]
root      5732     1  0 Jan31 ?        00:00:00 supervising syslog-ng    =
                                                                         =
                                   =20
root      5733  5732  0 Jan31 ?        00:00:00 syslog-ng --persist-file =
/var/lib/syslog-ng/syslog-ng.persist --cfgfile /etc/syslog-ng/syslog-ng.c=
onf --pidfile /var/run/syslog-ng.pid
root      5783     1  0 Jan31 ?        00:00:00 /sbin/rpcbind
root      5804     1  0 Jan31 ?        00:00:00 /sbin/rpc.statd --no-noti=
fy
root      5846     1  0 Jan31 ?        00:00:00 /usr/sbin/rpc.idmapd
root      5878     1  0 Jan31 ?        00:00:00 /usr/sbin/rpc.mountd
root      5882     2  0 Jan31 ?        00:00:00 [nfsd4]
root      5883     2  0 Jan31 ?        00:00:00 [nfsd4_callbacks]
root      5884     2  0 Jan31 ?        00:00:51 [lockd]
root      5887     2  0 Jan31 ?        00:01:49 [nfsd]
root      5888     2  0 Jan31 ?        00:01:02 [nfsd]
root      5889     2  0 Jan31 ?        00:01:00 [nfsd]
root      5890     2  0 Jan31 ?        00:01:09 [nfsd]
root      5891     2  0 Jan31 ?        00:02:00 [nfsd]
root      5892     2  0 Jan31 ?        00:00:56 [nfsd]
root      5893     2  0 Jan31 ?        00:02:34 [nfsd]
root      5894     2  0 Jan31 ?        00:02:27 [nfsd]
root      5922     1  0 Jan31 ?        00:00:00 /usr/sbin/automount -p /v=
ar/run/autofs.pid
root      5949     1  1 Jan31 ?        00:10:22 /usr/sbin/haveged -r 0 -w=
 1024 -v 1 -p /run/haveged.pid
nagios    5994     1  0 Jan31 ?        00:00:03 /usr/libexec/nrpe -c /etc=
/nagios/nrpe.cfg --daemon
nslcd     6017     1  0 Jan31 ?        00:00:00 /usr/sbin/nslcd
root      6056     1  0 Jan31 ?        00:00:01 /usr/bin/ruby19 /usr/bin/=
puppet agent --pidfile /var/run/puppet/puppet.pid
root      6091     1  0 Jan31 ?        00:00:00 /usr/sbin/sshd
root      6124     2  0 Jan31 ?        00:00:00 [kworker/1:1H]
root      6125     1  0 Jan31 ?        00:00:00 /usr/sbin/cron
root      6157     1  0 Jan31 tty1     00:00:00 /sbin/agetty 38400 tty1 l=
inux
root      6158     1  0 Jan31 tty2     00:00:00 /sbin/agetty 38400 tty2 l=
inux
root      6159     1  0 Jan31 tty3     00:00:00 /sbin/agetty 38400 tty3 l=
inux
root      6160     1  0 Jan31 tty4     00:00:00 /sbin/agetty 38400 tty4 l=
inux
root      6161     1  0 Jan31 tty5     00:00:00 /sbin/agetty 38400 tty5 l=
inux
root      6162     1  0 Jan31 tty6     00:00:00 /sbin/agetty 38400 tty6 l=
inux
root      6163     1  0 Jan31 ttyS0    00:00:00 /sbin/agetty -L 115200 tt=
yS0 vt100
root      6164     1  0 Jan31 ttyS1    00:00:00 /sbin/agetty -L 115200 tt=
yS1 vt100
root      6165     1  0 Jan31 ttyS2    00:00:00 /sbin/agetty -L 115200 tt=
yS2 vt100
root      7850     2  0 Jan31 ?        00:00:00 [kworker/5:1H]
root      7854     2  0 Jan31 ?        00:00:00 [kworker/6:1H]
root     26702     2  0 Jan31 ?        00:00:03 [kworker/5:1]
root     27203     2  0 Jan31 ?        00:00:03 [kworker/7:1]
root     27204     2  0 Jan31 ?        00:00:03 [kworker/2:1]
root     27208     2  0 Jan31 ?        00:00:03 [kworker/6:0]
root     27259     2  0 Jan31 ?        00:00:02 [kworker/6:1]
root     28023     2  0 Jan31 ?        00:00:03 [kworker/1:1]
root     28031     2  0 Jan31 ?        00:00:02 [kworker/4:3]
root     28049     2  0 Jan31 ?        00:00:01 [kworker/7:0]
root     28058     2  0 Jan31 ?        00:00:01 [kworker/5:0]
root     29609     2  0 Jan31 ?        00:00:00 [kworker/4:0]
root     30523     2  0 Jan31 ?        00:00:00 [kworker/3:1]
root     30539     2  0 Jan31 ?        00:00:00 [kworker/u32:1]
root     30611     2  0 00:10 ?        00:00:02 [kworker/0:3]
root     31434     2  0 00:40 ?        00:00:02 [kworker/0:0]
root     32216     2  0 00:47 ?        00:00:01 [kworker/0:1]
root     32217     2  0 00:47 ?        00:00:02 [kworker/0:2]
root     32218     2  0 00:47 ?        00:00:00 [kworker/u32:2]
root     32220  6091  0 00:49 ?        00:00:00 sshd: root@pts/0=20
root     32229 32220  0 00:49 pts/0    00:00:00 -bash
root     32255  6091  0 00:52 ?        00:00:00 sshd: root@pts/1=20
root     32264 32255  0 00:52 pts/1    00:00:00 -bash
root     32283     2  0 00:54 ?        00:00:00 [kworker/1:0]
root     32327     2  0 00:55 ?        00:00:00 [kworker/2:0]
root     32370     2  0 00:55 ?        00:00:00 [kworker/3:3]
root     32423     2  0 00:58 ?        00:00:01 [kworker/0:4]
root     32424     2  0 00:58 ?        00:00:01 [kworker/0:5]
root     32425     2  1 00:58 ?        00:00:03 [kworker/0:6]
root     32426     2  0 00:58 ?        00:00:00 [kworker/4:1]
root     32435     2  2 00:59 ?        00:00:02 [kworker/0:7]
root     32439     2  0 00:59 ?        00:00:00 [kworker/u32:0]
root     32464     2  2 01:00 ?        00:00:01 [kworker/0:8]
root     32465     2  1 01:00 ?        00:00:01 [kworker/0:9]
root     32467 32264  0 01:01 pts/1    00:00:00 -bash
root     32468 32264  0 01:01 pts/1    00:00:00 bash /usr/bin/wgetpaste
root     32470 32467  0 01:01 pts/1    00:00:00 ps -ef
/proc/1/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/10/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1000/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1001/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1002/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1079/stack
[<ffffffff815a1e7b>] ipmi_thread+0x12b/0x147
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/11/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1120/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1199/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/12/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1214/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1219/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1254/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1257/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1260/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1263/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1266/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1269/stack
[<ffffffff8165eec6>] scsi_error_handler+0x7d/0x4b7
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1279/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/13/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1348/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1415/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1424/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1430/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1431/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1432/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1468/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1469/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1470/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/15/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1539/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/16/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/1611/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/17/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/18/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/2/stack
[<ffffffff810fb15c>] kthreadd+0xbf/0x163
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/20/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/21/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/22/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/23/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/25/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/26/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/26702/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/27/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/27203/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/27204/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/27208/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/27259/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/28/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/28023/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/28031/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/28049/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/28058/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/29609/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/30/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/30523/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/30539/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/30611/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/31/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/31434/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32216/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32217/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32218/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32220/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32229/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32255/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32264/stack
[<ffffffff810e1238>] do_wait+0x1a1/0x229
[<ffffffff810e1f80>] SyS_wait4+0x96/0xc2
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32283/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32327/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32370/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32423/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32424/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32425/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32426/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32435/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32439/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32464/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32465/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32467/stack
[<ffffffff810e1238>] do_wait+0x1a1/0x229
[<ffffffff810e1f80>] SyS_wait4+0x96/0xc2
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/32468/stack
[<ffffffff811e963a>] pipe_wait+0x67/0x84
[<ffffffff811e9e18>] pipe_read+0x319/0x393
[<ffffffff811e2456>] do_sync_read+0x59/0x78
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/33/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3496/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/35/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3594/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3595/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3596/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3597/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3598/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/36/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3617/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3618/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3619/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3620/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3621/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3640/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3641/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3642/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3643/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3644/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3663/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3664/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3665/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3666/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3667/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3686/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3687/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3688/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3689/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3690/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/37/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3709/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3710/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3711/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3712/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3713/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3732/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3733/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3734/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3735/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3736/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3755/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3756/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3757/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3758/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3759/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3778/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3779/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3780/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3781/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3782/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/38/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3802/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3803/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3804/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3805/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3806/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3825/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3826/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3827/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3828/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3829/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3848/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3849/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3850/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3851/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3852/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3871/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3872/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3873/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3874/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3875/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3894/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3895/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3896/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3897/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3898/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3917/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3918/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3919/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3920/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3921/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3941/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3942/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3943/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3944/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/3945/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/40/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/41/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4166/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4167/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4168/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4169/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4170/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4171/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4172/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4173/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4174/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4175/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4176/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4177/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4178/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4179/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4180/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4181/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4182/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4183/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4184/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4185/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4186/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4187/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4188/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4189/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4190/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4191/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4192/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4193/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4194/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4195/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4196/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4197/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4198/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4199/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/42/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4200/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4201/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4202/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4203/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4204/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4205/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4206/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4207/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4208/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4209/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4210/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4211/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4212/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4213/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4214/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4215/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4216/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4217/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4218/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4219/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4220/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4221/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4222/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4223/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4224/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4225/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4226/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4227/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4228/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4229/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4230/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4231/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4232/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4233/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4234/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4235/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4236/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4237/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4238/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4239/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4240/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4241/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4242/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4243/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4244/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4245/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4246/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4247/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4248/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4249/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4250/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4267/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4272/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4279/stack
[<ffffffff811c7289>] cv_wait_common+0x96/0x128
[<ffffffff811c734a>] __cv_wait_interruptible+0x15/0x17
[<ffffffff81271592>] txg_quiesce_thread+0x56/0x351
[<ffffffff811c3787>] thread_generic_wrapper+0x71/0x7e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4280/stack
[<ffffffff81252f86>] dsl_scan_scrub_cb+0x3dc/0x42f
[<ffffffff81253e44>] dsl_scan_visitbp.isra.5+0x884/0x8e8
[<ffffffff81254189>] dsl_scan_visitds+0x157/0x341
[<ffffffff81254eb1>] dsl_scan_sync+0x41b/0x6e4
[<ffffffff8126365c>] spa_sync+0x53f/0x952
[<ffffffff812712c7>] txg_sync_thread+0x233/0x4a8
[<ffffffff811c3787>] thread_generic_wrapper+0x71/0x7e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4295/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/43/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4311/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4477/stack
[<ffffffff812c24b3>] ep_poll+0x196/0x2f2
[<ffffffff812c323c>] SyS_epoll_wait+0x8e/0xcb
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/45/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/46/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/47/stack
[<ffffffff81648189>] devtmpfsd+0x121/0x13f
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4769/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/48/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4936/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4939/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4942/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4946/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4949/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4952/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4955/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4958/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/4962/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5165/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/542/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/544/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5449/stack
[<ffffffff812c24b3>] ep_poll+0x196/0x2f2
[<ffffffff812c323c>] SyS_epoll_wait+0x8e/0xcb
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5452/stack
[<ffffffff8114680b>] kauditd_thread+0x11e/0x161
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/546/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5732/stack
[<ffffffff810e1238>] do_wait+0x1a1/0x229
[<ffffffff810e1f80>] SyS_wait4+0x96/0xc2
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5733/stack
[<ffffffff812c24b3>] ep_poll+0x196/0x2f2
[<ffffffff812c323c>] SyS_epoll_wait+0x8e/0xcb
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5783/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3a65>] do_sys_poll+0x3dc/0x481
[<ffffffff811f3bb0>] SyS_poll+0x54/0xbd
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5804/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5846/stack
[<ffffffff812c24b3>] ep_poll+0x196/0x2f2
[<ffffffff812c323c>] SyS_epoll_wait+0x8e/0xcb
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5878/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5882/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5883/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5884/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813f6d1d>] lockd+0xe3/0x12e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5887/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5888/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5889/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5890/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5891/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5892/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5893/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5894/stack
[<ffffffff819a0ad0>] svc_get_next_xprt+0x182/0x246
[<ffffffff819a0d07>] svc_recv+0xcb/0x37b
[<ffffffff813d19c0>] nfsd+0xba/0x11e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5922/stack
[<ffffffff810eded6>] do_sigtimedwait+0xf8/0x1b4
[<ffffffff810ee01a>] SyS_rt_sigtimedwait+0x88/0xbb
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5949/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/5994/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6017/stack
[<ffffffff810fdb6a>] hrtimer_nanosleep+0x8d/0xfe
[<ffffffff810fdc3b>] SyS_nanosleep+0x60/0x69
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6056/stack
[<ffffffff8112eda4>] futex_wait_queue_me+0xd8/0x11a
[<ffffffff8112f6ea>] futex_wait+0x114/0x22b
[<ffffffff81130b9f>] do_futex+0xb4/0x875
[<ffffffff81131485>] SyS_futex+0x125/0x158
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6091/stack
[<ffffffff811f27fe>] poll_schedule_timeout+0x43/0x66
[<ffffffff811f3122>] do_select+0x5ed/0x62c
[<ffffffff811f33fc>] core_sys_select+0x29b/0x2c1
[<ffffffff811f34a6>] SyS_select+0x84/0xba
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6124/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6125/stack
[<ffffffff810fdb6a>] hrtimer_nanosleep+0x8d/0xfe
[<ffffffff810fdc3b>] SyS_nanosleep+0x60/0x69
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6157/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6158/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6159/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6160/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6161/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6162/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6163/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6164/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/6165/stack
[<ffffffff815e9c69>] n_tty_read+0x4a5/0x98c
[<ffffffff815e4d30>] tty_read+0x82/0xc6
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/7/stack
[<ffffffff81125d2f>] rcu_gp_kthread+0x2b5/0x517
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/701/stack
[<ffffffff8177f663>] hub_thread+0x10d8/0x11d0
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/710/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/7850/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/7854/stack
[<ffffffff810f58c1>] worker_thread+0x291/0x2d1
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/8/stack
[<ffffffff81125af2>] rcu_gp_kthread+0x78/0x517
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/849/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/851/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/9/stack
[<ffffffff81100199>] smpboot_thread_fn+0x115/0x153
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/932/stack
[<ffffffff8114fb5f>] watchdog+0x47/0x293
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/939/stack
[<ffffffff8118c8df>] kswapd+0x26f/0x3b4
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/940/stack
[<ffffffff811b4fba>] ksm_scan_thread+0xd17/0xe09
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/941/stack
[<ffffffff811bd04d>] khugepaged+0xde9/0xf5b
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/942/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/943/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/944/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/945/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/946/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/947/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/948/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/949/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/950/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/953/stack
[<ffffffff811c7125>] __cv_timedwait_common+0xb0/0x154
[<ffffffff811c71dc>] __cv_timedwait_interruptible+0x13/0x15
[<ffffffff8122647f>] arc_adapt_thread+0xda/0x194
[<ffffffff811c3787>] thread_generic_wrapper+0x71/0x7e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/954/stack
[<ffffffff811c7125>] __cv_timedwait_common+0xb0/0x154
[<ffffffff811c71dc>] __cv_timedwait_interruptible+0x13/0x15
[<ffffffff812244af>] l2arc_feed_thread+0xac/0xb33
[<ffffffff811c3787>] thread_generic_wrapper+0x71/0x7e
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/955/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/956/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/957/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/958/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/959/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/960/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/961/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/962/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/963/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/964/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/965/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/966/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/967/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/968/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/969/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/970/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/971/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/972/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/973/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/974/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/975/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/976/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/977/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/978/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/979/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/980/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/981/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/982/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/983/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/984/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/985/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/986/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/987/stack
[<ffffffff811c40e6>] taskq_thread+0x103/0x303
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/991/stack
[<ffffffff812bf818>] fsnotify_mark_destroy+0x10b/0x122
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/995/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/996/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/999/stack
[<ffffffff810f5609>] rescuer_thread+0x23d/0x264
[<ffffffff810faab3>] kthread+0xea/0xf2
[<ffffffff819ebc6c>] ret_from_fork+0x7c/0xb0
[<ffffffffffffffff>] 0xffffffffffffffff
/proc/self/stack
[<ffffffff8104c684>] save_stack_trace_tsk+0x23/0x40
[<ffffffff812de362>] proc_pid_stack+0x71/0xcc
[<ffffffff812dc65f>] proc_single_show+0x54/0x80
[<ffffffff811ff653>] seq_read+0x165/0x346
[<ffffffff811e2fb9>] vfs_read+0x9b/0x12a
[<ffffffff811e3184>] SyS_read+0x49/0x7f
[<ffffffff819ebd12>] system_call_fastpath+0x16/0x1b
[<ffffffffffffffff>] 0xffffffffffffffff

--------------090509050207080408060502
Content-Type: application/pgp-keys;
 name="0x40AC5AC3.asc"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0x40AC5AC3.asc"

-----BEGIN PGP PUBLIC KEY BLOCK-----
Version: GnuPG v2.0.22 (GNU/Linux)

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
XWPW2DfAEjM2nw=3D=3D
=3DCiwU
-----END PGP PUBLIC KEY BLOCK-----

--------------090509050207080408060502--

--6coLEH5iGEt3i1KiFe4W2LINGcmx6trN8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIcBAEBAgAGBQJS7GDMAAoJECRx6z5ArFrDXFUQAN/ybOfXfn/FRrKjznWjC+Pi
57U1iytkwvPKZN95Jdug/JBIAa/8/0/xlJ/CjdK1vgtx3KNb/MQBDEwqcd97dSjx
BqSIMdFYLZ181R08Tctmr7YrXjQCB4JR15jg7zQ31nI+OnJP+XKGoebu9BGpVIRx
xdUKDfGbrtCrS73LuP6Fo0F1d7qXbljqhLUuk8OyFDuGxybSbTGigD8XDwUEoWaM
bV0UQXmBB/8F87rA2BEAU4ZCoYakdeofKO+oa+zrmklf2YO9+5MoQ2b2aVFePKG2
zR8eCaqbyfCoBGeoHnFdNKSpRzxfA61tC+hDqU4wX4rnByzDLetZo+qVMb2IFGa7
95ho7UVfcOo+AKBkqOP2droltbRzbjSdTi5CI7zGanLXEYau4RDK/775dkiyS6Ti
nHUd/pY0nWpc1gX6GYu0AzS0IoJHeVZYlkqnOdoW5nhY1dr3mp2Argfrg5wuMivb
fRT7VmIk8vL+RtZv0QyrpG2VDpwJ7g0dm+ytawoa3Vqc4yY7iXjOCarUNR/3FVm0
RNkUerUT4UV2gdMT+2t8X6dTri29bJ1ukvO3OuP/C616DcPUUGCW2XMn0Vz7xLLp
WdATK8M4OtlSCK6x/uXn8SgBPgorm1VDHS03FA3BcZArL0xwlGE6Z8o9paEnE83M
cpRd6/2sAAZxpTmTvkDF
=M7iB
-----END PGP SIGNATURE-----

--6coLEH5iGEt3i1KiFe4W2LINGcmx6trN8--
