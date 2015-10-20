From: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: NULL pointer dereference: IP: [<f828a00c>]
 sr_runtime_suspend+0xc/0x20 [sr_mod]
Date: Tue, 20 Oct 2015 02:39:19 +0100
Message-ID: <1445305159.2561.16.camel@decadent.org.uk>
References: <1444957547.1325.2.camel@giantmonkey.de>
	 <1444982077.2350.0.camel@giantmonkey.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kUnr68YLRKp+sKhxP/Wh"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36353 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751846AbbJTBjc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 21:39:32 -0400
In-Reply-To: <1444982077.2350.0.camel@giantmonkey.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paul Menzel <paul.menzel@giantmonkey.de>, "James E. J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: submit@bugs.debian.org


--=-kUnr68YLRKp+sKhxP/Wh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2015-10-16 at 09:54 +0200, Paul Menzel wrote:
[...]
> > BUG: unable to handle kernel NULL pointer dereference at 00000014
> > IP: [] sr_runtime_suspend+0xc/0x20 [sr_mod]
> > *pdpt =3D 000000003696e001 *pde =3D 000000000000000000
> > Oops: 0000 [#1] SMB
> > Modules linked in: sd_mod(+) sr_mod(+) cdrom ata_generic ohci_pci ahci =
libahci pata_amd firwire_ohci firewire_core crc_iti_t forcedeth libata scsi=
_mod ohci_hcd ehci_pci ehci_hcd usbcore usb_common fan thermal thermal_sys =
floppy(+)
> > CPU: 1 PID: 73 Comm: systemd-udevd Not tainted 4.2.0-1-686-pae #1 Debia=
n 4.2.3-1
> > Hardware name: Packard Bell imedia S3210/WMCP78M, BIOs P01-B2 11/06/200=
9
> > task: f68dd040 ti: f6988000 task.ti: f6988000
> > EIP: 0060:[] EFLAGS: 00010246 CPU: 1
> > EIP is at sr_runtime_suspend+0xc/0x20 [sr_mod]
> > EAX: 00000000 EBX: f6a30cd8 ECX: f6c03d2c EDX: 00000000
> > ESI: 00000000 EDI: f828e100 EBP: f6989ba8 ESP: f6989b88
> > =C2=A0DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
> > CR0: 8005003b CR2: 00000014 CR3: 3696d780 CR4: 000006f0
> > Stack:
> > =C2=A0af83346c3 00000000 00000001 fffffff5 f6a7d150 f6a30cd8 f6a30d3c 0=
0000000
> > =C2=A0f6989bbc c1390cb7 f6a30cd8 f8334660 00000000 f6989bd0 c1390d0f f6=
a30cd8
> > =C2=A0f8334660 00000000 f6989c0c c13916cb f694a614 f68dd040 00000000 00=
000008
> > Call Trace:
> > =C2=A0[=E2=80=A6] ? scsi_runtime_suspend+0x63/0xa0 [scsi_mod]
> > =C2=A0[=E2=80=A6] ? __rpm_callback+0x27/0x60
> > [=E2=80=A6]
[...]
> Ben Hutchings asked me to test the patch below to get more debug
> information.
[...]

Well, that didn't help much. =C2=A0Paul hit another oops, this time in
sd_mod but again apparently related to runtime PM. =C2=A0My patch only
touched sr_mod.

This time he sent photos of the complete oops; see
<https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D801925;filename=3D2015=
1020_005.jpg;att=3D4;msg=3D15>
and
<https://bugs.debian.org/cgi-bin/bugreport.cgi?filename=3D20151020_006.jpg;=
bug=3D801925;att=3D3;msg=3D15>

Ben.

--=20
Ben Hutchings
The first rule of tautology club is the first rule of tautology club.
--=-kUnr68YLRKp+sKhxP/Wh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIVAwUAViWbR+e/yOyVhhEJAQpgYRAAkvWV8IfRycFy/tp4qesrMBfJAmQQi7HU
UPuQoVIbjcMG/SKBikTkQuNwqyEkT3hWRBujMMx4945pu2V7bNUAMjaIfzcTGGV/
m2mPfZ+pTNBkw90f3Wpf75uuTbOoS0bfQqrPUF2LBDXmihsv+ieUCqhUxklHhwHw
iexJ0UWA2fQxQBG82SQJ2Kb4Y+SQ0RCWG2fgdgqtw8pUJFeULJdGh+u3EYCGKqO4
XkxlJ3ZNvu5SnBU3CbHlc6/pi43ySUkLDeRHYZ7wF4VYlz0qnzL7ysipPNNC+VCw
GyDc1w8s5PajGLdAEFvI/gb7yYWWBnumKfw3KOI1gfRpyxfpiW5iRkOIP+KnVGwo
6JkXfA3QXH58IoYfNsK6j8RFViQ7YwFOVPC9D6mACBnss7sslrmIG7gs25sqYEsh
P89k014Z3fNnG/6xETgZ3rulYQfVG5IA87L4gh3Ncm2vEsGBVF0JNhjt1Bun+yOe
j3DxHzQcYQgrS2gRI7U0IGXpujNeC7SjsRB3PRSNa409Ye66PZxbgELzXvbXzVvy
BunonXIoVBr8h2P+bJIWyP0nqh5Eb6DDeLkrB/pz5weTxXBzNK2myQ/kMIFsObc2
LD+IS4o96AQghpQSzu3+s+/V5JGh8ASOQqiZR6FnPMnzwnMeX+Y81fjUkolKdEkv
Um3Ie35/f08=
=TjiC
-----END PGP SIGNATURE-----

--=-kUnr68YLRKp+sKhxP/Wh--
