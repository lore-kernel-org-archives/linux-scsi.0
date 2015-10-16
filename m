From: Paul Menzel <paul.menzel@giantmonkey.de>
Subject: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Fri, 16 Oct 2015 03:05:47 +0200
Message-ID: <1444957547.1325.2.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-Q5gyE3KCe38VUgB2mrh4"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lf0-f42.google.com ([209.85.215.42]:35493 "EHLO
	mail-lf0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968AbbJPBGD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 21:06:03 -0400
Received: by lffy185 with SMTP id y185so58266104lff.2
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2015 18:06:00 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: "James E. J. Bottomley" <JBottomley@odin.com>


--=-Q5gyE3KCe38VUgB2mrh4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Dear Linux SCSI folks,


using Debian Sid/unstable with Linux 4.2.3-1 upgrading from systemd
227-1 to 227-2 [1] and other packages, the system doesn=E2=80=99t start up
anymore and the /dev/md1 device doesn=E2=80=99t seem to be found and I am
dropped into shell from initramfs (BusyBox).

Only having wireless LAN and no serial or USB debug capabilities, and
mount a USB storage device did not work, I manually copied the beginning
of the Oops.

```
BUG: unable to handle kernel NULL pointer dereference at 00000014
IP: [<f828a00c>] sr_runtime_suspend+0xc/0x20 [sr_mod]
*pdpt =3D 000000003696e001 *pde =3D 000000000000000000
Oops: 0000 [#1] SMB
Modules linked in: sd_mod(+) sr_mod(+) cdrom ata_generic ohci_pci ahci liba=
hci pata_amd firwire_ohci firewire_core crc_iti_t forcedeth libata scsi_mod=
 ohci_hcd ehci_pci ehci_hcd usbcore usb_common fan thermal thermal_sys flop=
py(+)
CPU: 1 PID: 73 Comm: systemd-udevd Not tainted 4.2.0-1-686-pae #1 Debian 4.=
2.3-1
Hardware name: Packard Bell imedia S3210/WMCP78M, BIOs P01-B2 11/06/2009
task: f68dd040 ti: f6988000 task.ti: f6988000
EIP: 0060:[<fh28a00c>] EFLAGS: 00010246 CPU: 1
EIP is at sr_runtime_suspend+0xc/0x20 [sr_mod]
EAX: 00000000 EBX: f6a30cd8 ECX: f6c03d2c EDX: 00000000
ESI: 00000000 EDI: f828e100 EBP: f6989ba8 ESP: f6989b88
 DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
CR0: 8005003b CR2: 00000014 CR3: 3696d780 CR4: 000006f0
Stack:
 af83346c3 00000000 00000001 fffffff5 f6a7d150 f6a30cd8 f6a30d3c 00000000
 f6989bbc c1390cb7 f6a30cd8 f8334660 00000000 f6989bd0 c1390d0f f6a30cd8
 f8334660 00000000 f6989c0c c13916cb f694a614 f68dd040 00000000 00000008
Call Trace:
 [=E2=80=A6] ? scsi_runtime_suspend+0x63/0xa0 [scsi_mod]
 [=E2=80=A6] ? __rpm_callback+0x27/0x60
[=E2=80=A6]
```

I tried also to boot with Linux 4.1 and it fails the same way.

Is that a known problem and has been fixed in the mean time? It=E2=80=99d b=
e
great if you helped me getting the system to boot again. Please tell me
if you need more information to debug this issue and I=E2=80=99ll do my bes=
t to
get it.


Thanks,

Paul


[1] http://metadata.ftp-master.debian.org/changelogs//main/s/systemd/system=
d_227-2_changelog

--=20
GPG-Schl=C3=BCssel: 33623E9B
Fingerabdruck =3D 0EB1 649D 4361 D04F 3C70  6F71 4DD7 BF75 3362 3E9B

Giant Monkey Software Engineering GmbH

Brunnenstr. 7D
10119 Berlin Mitte

Gesch=C3=A4ftsf=C3=BChrer Adrian Fuhrmann, Lion Vollnhals und Paul Menzel

USt-IdNr.: DE281524720
HRB 139495 B Amtsgericht Charlottenburg

--=-Q5gyE3KCe38VUgB2mrh4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJWIE11AAoJEE3Xv3UzYj6brp0P/1RRcaX2ypxvWgv++DCgKdx/
fdiCC/uub5OLWY7yslVXgNCe4yw5FrXfVcJZ9rLNGdx7QKWlq9bqHcJGdfcDQiWW
wAc1gheIH8Isj1oS755Deh+04W/RxmO4ttQCYoTslo440GaDuDTHsOTG8QdlNZ4t
rC+S1UhJJvfk4yCgifeAt+5zSqSNV2y7mnmE1cE76A4lcJsGHEXaBqWXQBt6T5Dt
QT7PUlgU3l0Chm8wKbPCK2IsNAbl7Kbc2DNIC9fVkFCrJgEMSFKRdXumIiCHpVkp
766znk9ziBcPiCS+bBrZktR4m7K/RFY3rY3G9sBXDZBQW3xSdnn0bCu5RypFVnCD
vy0Wy5bU/u/fQ4DI3gWHza7MMRKKhOF/NTPe80oDH2Xjc5FfqtdO9UivkOWeK9Q2
G+IgIPqDlNmp3VZOBSUEJgHBED47lkoFUK5I6qHjW9owy4mx73i0UgBPsyLQtNhD
L9Yt/jv7/P6RzYYPR/NRTQHIajqE6B2gvHrQMNkJMXy7Vf0bmPgfx5IttPAOkn5Z
fcxNhYp95RbK/qZf91ORYqwJI8m5h13CapYqHovvVcScRVVt7RzRZdj5EgIgSXQT
2TkqnWaO7StxsNxhISwZJdA68rQzqoTbBhBI5Ow1Ow1vTmDrcBiHkrjfx4u+TC7v
U0N9+2Ye1AbNlqImpK7u
=dWkC
-----END PGP SIGNATURE-----

--=-Q5gyE3KCe38VUgB2mrh4--

