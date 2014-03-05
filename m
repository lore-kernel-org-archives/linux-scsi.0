From: markus <markus@kola.li>
Subject: Re: Slow I/O performance on SAS1064
Date: Wed, 5 Mar 2014 22:40:14 +0100
Message-ID: <20140305214013.GA6287@localhost.localdomain>
References: <20140305175036.GA23885@localhost.localdomain>
 <CAK2H+ecJKp+QLJsbGW2tquO5_DuQReJD8nKViHea9tTiJwfn-g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/04w6evG8XlLl3ft"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAK2H+ecJKp+QLJsbGW2tquO5_DuQReJD8nKViHea9tTiJwfn-g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com, DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org, Linux Kernel List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 05, 2014 at 10:21:07AM -0800, Mark Knecht wrote:
> On Wed, Mar 5, 2014 at 9:50 AM, Markus <markus@kola.li> wrote:
> <SNIP>
>=20
> > The hdparm result looks like there is somethink not right . There were =
no features supported but why ?
>=20
>=20
> Does the HDD have S.M.A.R.T. features? Possibly
>=20
> smartctl -a /dev/sda
root@outpost:~# smartctl -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [sparc64-linux-3.13.5-mar] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net


Probable ATA device behind a SAT layer
Try an additional '-d ata' or '-d sat' argument.

so i try it with scsi.=20

root@outpost:~# smartctl -d scsi -a /dev/sda
smartctl 5.41 2011-06-09 r3365 [sparc64-linux-3.13.5-mar] (local build)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.net

User Capacity:        2,000,398,934,016 bytes [2.00 TB]
Logical block size:   512 bytes
Logical Unit id:      0x50000394e2380537
Serial number:                   7365P4KNT
Device type:          disk
Local Time is:        Wed Mar  5 22:32:09 2014 CET
Device supports SMART and is Disabled
Temperature Warning Disabled or Not Supported
SMART Health Status: OK

Error Counter logging not supported
Device does not support Self Test logging


>=20
> would provide some additional visibility?
=2E....
[   98.037209] Uniform Multi-Platform E-IDE driver
[   98.107564] SLAB: Unable to allocate memory on node 0 (gfp=3D0x40d1)
[   98.188985]   cache: dma-kmalloc-512, object size: 512, order: 0
[   98.268127]   node 0: slabs: 0/0, objs: 0/0, free: 0
[   98.333538] sr: out of memory.
[   98.373628] cdrom: Uniform CD-ROM driver Revision: 3.20
[   98.443390] sr 0:0:0:0: Attached scsi CD-ROM sr0
[   98.448375] sr 0:0:0:0: Attached scsi generic sg0 type 5
[  103.198705] scsi2 : ioc0: LSISAS1064 A3, FwRev=3D01080400h, Ports=3D1, M=
axQ=3D511, IRQ=3D10
[  103.329805] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 0, =
phy 0, sas_addr 0x1221000000000000
[  103.462762] scsi 2:0:0:0: Direct-Access     ATA      TOSHIBA MQ01ABB2 0U=
   PQ: 0 ANSI: 5
[  103.571610] scsi 2:0:0:0: Attached scsi generic sg1 type 0
[  103.645418] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 1, =
phy 1, sas_addr 0x1221000001000000
[  103.777635] scsi 2:0:1:0: Direct-Access     ATA      TOSHIBA MQ01ABB2 0U=
   PQ: 0 ANSI: 5
[  103.886607] scsi 2:0:1:0: Attached scsi generic sg2 type 0
[  103.960517] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 2, =
phy 2, sas_addr 0x1221000002000000
[  104.093109] scsi 2:0:2:0: Direct-Access     ATA      TOSHIBA MQ01ABB2 0U=
   PQ: 0 ANSI: 5
[  104.201973] scsi 2:0:2:0: Attached scsi generic sg3 type 0
[  104.275830] mptsas: ioc0: attaching sata device: fw_channel 0, fw_id 3, =
phy 3, sas_addr 0x1221000003000000
[  104.408412] scsi 2:0:3:0: Direct-Access     ATA      TOSHIBA MQ01ABB2 0U=
   PQ: 0 ANSI: 5
[  104.517379] scsi 2:0:3:0: Attached scsi generic sg4 type 0
[  104.618997] sd 2:0:0:0: [sda] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[  104.721185] sd 2:0:3:0: [sdd] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[  104.823771] sd 2:0:1:0: [sdb] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[  104.824017] sd 2:0:2:0: [sdc] 3907029168 512-byte logical blocks: (2.00 =
TB/1.81 TiB)
[  104.828691] sd 2:0:0:0: [sda] Write Protect is off
[  104.828697] sd 2:0:0:0: [sda] Mode Sense: 67 00 00 08
[  104.829940] sd 2:0:2:0: [sdc] Write Protect is off
[  104.829945] sd 2:0:2:0: [sdc] Mode Sense: 67 00 00 08
[  104.830488] sd 2:0:3:0: [sdd] Write Protect is off
[  104.830493] sd 2:0:3:0: [sdd] Mode Sense: 67 00 00 08
[  104.833225] sd 2:0:0:0: [sda] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  104.834471] sd 2:0:2:0: [sdc] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  104.835118] sd 2:0:3:0: [sdd] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  105.583175] sd 2:0:1:0: [sdb] Write Protect is off
[  105.623801]  sda: sda1 sda2 sda3
[  105.651118]  sdc: sdc1 sdc9
[  105.654024]  sdd: sdd1 sdd9
[  105.761966] sd 2:0:1:0: [sdb] Mode Sense: 67 00 00 08
[  105.769029] sd 2:0:1:0: [sdb] Write cache: enabled, read cache: enabled,=
 doesn't support DPO or FUA
[  105.775293] sd 2:0:2:0: [sdc] Attached SCSI disk
[  105.775941] sd 2:0:3:0: [sdd] Attached SCSI disk
[  106.014357] sd 2:0:0:0: [sda] Attached SCSI disk
[  106.158864]  sdb: sdb1 sdb9
[  106.205879] sd 2:0:1:0: [sdb] Attached SCSI disk
[  106.502387] random: nonblocking pool is initialized
[  106.792978] device-mapper: uevent: version 1.0.3
[  106.861434] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised:=
 dm-devel@redhat.com
[  108.085062] bio: create slab <bio-1> at 1
=2E....
>=20
> - Mark

Markus

--/04w6evG8XlLl3ft
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJTF5m9AAoJENNjYPi2hQIwxUwP/2Ye6ToVd2vF9TauPsWlHbe1
A857H/nA0VBpHuHBsrPjbXIb5P33P3TEA3NcU5fppmKSAS4tiwM6OZlcq7E9qHyA
LNpmkOcPYakmINxkUIS2PMdvMbOhfTi6iMwLPMh2hS95WhUUzBSms0SlInjUtOaA
qMQvV9XadbPlHbLue05g4uhWKsBJQerTqGJegB7arPMXByyOG6rRJM7t3IYxQ+4I
qV4+jZM21RmLyxPu37dg2Xbf3ggpylNCQj4oY1X0vFjelbb0UxWXIKnup1wsVoXw
nfGOWvB5yxBBy8IgJqloOFQCm5CTYeqKlL6OyCJyLnWaIHjB3WXMk5ddbSa2WKvi
ZyoqjrZkP8NhAqRkFNNabZUIK0mjRjqRxy0INBLpdGWkqvJNb83m/HSwrJGCQpxO
ZH69LJY6WKj1uoG/NZ/wLk8NdJRsZDKaJ7A2hs+8bnBZ2rYH9jCrPSfXUEl2YLsk
jl+C5WWTdpK47GmcKOM6JEotOspvNJagYtFDTlbh36xv5gpDKjeAuQxrDRhBSLTa
PhxNveLDUhoa4Vh5b8GO8WaY1IJHDXM6QuzImuMR5Qmcbr2V+Y+FLpGKSDhLmIHB
Bhtjj4J+0ERpb5y3Ke1GpINBPjL7Hsl5PrxLhvMl4pH9ClnWVHWROQlBqc3VTy8t
NXBPfnHbORYhsvwxM34x
=2wbM
-----END PGP SIGNATURE-----

--/04w6evG8XlLl3ft--
