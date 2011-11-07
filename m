From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: WARNING: at drivers/scsi/scsi_lib.c:1704
Date: Mon, 7 Nov 2011 17:24:08 +1100
Message-ID: <20111107172408.834c6ffcecfe35f7452c7e60@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_17_24_08_+1100_=mWbpLo469CnuKwn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: Bart Van Assche <bvanassche@acm.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

--Signature=_Mon__7_Nov_2011_17_24_08_+1100_=mWbpLo469CnuKwn
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Starting some time last week I am getting the following during boot on
our PPC970 blade:

calling  .ipr_init+0x0/0x68 @ 1
ipr: IBM Power RAID SCSI Device Driver version: 2.5.2 (April 27, 2011)
ipr 0000:01:01.0: Found IOA with IRQ: 26
ipr 0000:01:01.0: Starting IOA initialization sequence.
ipr 0000:01:01.0: Adapter firmware version: 06160039
ipr 0000:01:01.0: IOA initialized.
scsi0 : IBM 572E Storage Adapter
------------[ cut here ]------------
WARNING: at drivers/scsi/scsi_lib.c:1704
Modules linked in:
NIP: c00000000053b3d4 LR: c00000000053e5b0 CTR: c000000000541d70
REGS: c0000000783c2f60 TRAP: 0700   Not tainted  (3.1.0-autokern1)
MSR: 8000000000029032 <EE,ME,CE,IR,DR>  CR: 24002024  XER: 20000002
TASK =3D c0000000783b8000[1] 'swapper' THREAD: c0000000783c0000 CPU: 0
GPR00: 0000000000000001 c0000000783c31e0 c000000000cf38b0 c00000000239a9d0=
=20
GPR04: c000000000cbe8f8 0000000000000000 c0000000783c3040 0000000000000000=
=20
GPR08: c000000075daf488 c000000078a3b7ff c000000000bcacc8 0000000000000000=
=20
GPR12: 0000000044002028 c000000007ffb000 0000000002e40000 000000000099b800=
=20
GPR16: 0000000000000000 c000000000bba5fc c000000000a61db8 0000000000000000=
=20
GPR20: 0000000001b77200 0000000000000000 c000000078990000 0000000000000001=
=20
GPR24: c000000002396828 0000000000000000 0000000000000000 c000000078a3b938=
=20
GPR28: fffffffffffffffa c0000000008ad2c0 c000000000c7faa8 c00000000239a9d0=
=20
NIP [c00000000053b3d4] .scsi_free_queue+0x24/0x90
LR [c00000000053e5b0] .scsi_alloc_sdev+0x280/0x2e0
Call Trace:
[c0000000783c31e0] [c000000000c7faa8] wireless_seq_fops+0x278d0/0x2eb88 (un=
reliable)
[c0000000783c3270] [c00000000053e5b0] .scsi_alloc_sdev+0x280/0x2e0
[c0000000783c3330] [c00000000053eba0] .scsi_probe_and_add_lun+0x390/0xb40
[c0000000783c34a0] [c00000000053f7ec] .__scsi_scan_target+0x16c/0x650
[c0000000783c35f0] [c00000000053fd90] .scsi_scan_channel+0xc0/0x100
[c0000000783c36a0] [c00000000053fefc] .scsi_scan_host_selected+0x12c/0x1c0
[c0000000783c3750] [c00000000083dcb4] .ipr_probe+0x2c0/0x390
[c0000000783c3830] [c0000000003f50b4] .local_pci_probe+0x34/0x50
[c0000000783c38a0] [c0000000003f5f78] .pci_device_probe+0x148/0x150
[c0000000783c3950] [c0000000004e1e8c] .driver_probe_device+0xdc/0x210
[c0000000783c39f0] [c0000000004e20cc] .__driver_attach+0x10c/0x110
[c0000000783c3a80] [c0000000004e1228] .bus_for_each_dev+0x98/0xf0
[c0000000783c3b30] [c0000000004e1bf8] .driver_attach+0x28/0x40
[c0000000783c3bb0] [c0000000004e07d8] .bus_add_driver+0x218/0x340
[c0000000783c3c60] [c0000000004e2a2c] .driver_register+0x9c/0x1b0
[c0000000783c3d00] [c0000000003f62d4] .__pci_register_driver+0x64/0x140
[c0000000783c3da0] [c000000000b99f88] .ipr_init+0x4c/0x68
[c0000000783c3e20] [c00000000000ad24] .do_one_initcall+0x1a4/0x1e0
[c0000000783c3ee0] [c000000000b512d0] .kernel_init+0x14c/0x1fc
[c0000000783c3f90] [c000000000022468] .kernel_thread+0x54/0x70
Instruction dump:
ebe1fff8 7c0803a6 4e800020 7c0802a6 fba1ffe8 fbe1fff8 7c7f1b78 f8010010=20
f821ff71 e8030398 3120ffff 7c090110 <0b000000> e86303b0 482de065 60000000=20
---[ end trace 759bed76a85e8dec ]---
scsi 0:0:1:0: Direct-Access     IBM-ESXS MAY2036RC        T106 PQ: 0 ANSI: 5
------------[ cut here ]------------

I get lots more of these.  The obvious commit to point the finger at
is 3308511c93e6 ("[SCSI] Make scsi_free_queue() kill pending SCSI
commands") but the root cause may be something different.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_17_24_08_+1100_=mWbpLo469CnuKwn
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOt3mIAAoJEECxmPOUX5FEAloP/0N6rjRdcdNBrd2YJHh5lqeo
lL3dUUrKfG5cZUuw7e7hTsKVjJPyGeKO2LPp+nX3b5Z7rjYNuvhd/RVZ/oteHVoM
qwO5168F3Ro7K7pLmjXkarrmvlsW/vG1UTtq8VK9Ta3Y91Qs/sWff0hoH5MYuLpB
u6w7zSBXgO9TiV25Cp4LmVutvfeJaZ8CHvEEysImdnzePmYm19MtB7+MlDJWzhKN
f91NVjOXifNZC80dGq60poB9Gdk1ENKtfOoGhX5EwJSJyKK1xy3ai3l1InHOpX3q
QVWIy4gN2RGaqThnYDTz/r9ImTxyxPfnAnHyda5iq70VZdYYr9nrpFgPtdHFercn
klpa+fC1J8ZFXfX7SgtgSPZU3uVvYktPtygAjt2dEn6TolpZRwHdbF44kK7uga2C
wjcKT1fBtJVsawbX4jGWZd9POcv3WPwqVfM66dET+YEUIzzDUwJHgMsdEn8XVaCL
Gb6SCtOY4bAjOh0VSqmItanxve0C/i1J2PRVnDWUgLQiYC9t+WFjYbsq/XPBNG2u
Ro5Z0z2mvSvUkN82q6whscDoB+ZJB5b7yzygr9kcvmHRh4oJhQwNXirN4HwvGGjj
81OP3HtLjedkNZ1Z/TTsDG8I7R6Y1y1SA2k6ORsfqSwhLjY4DyRXhtINUrvGuHy7
UPGAwWTE5yjCyK9xdwD9
=pYCY
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_17_24_08_+1100_=mWbpLo469CnuKwn--
