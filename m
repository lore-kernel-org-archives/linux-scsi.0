From: florin@iucha.net (Florin Iucha)
Subject: Fwd: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
Date: Fri, 16 May 2003 10:56:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030516155621.GB11432@iucha.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iucha.net ([209.98.146.184]:40564 "EHLO mail.iucha.net")
	by vger.kernel.org with ESMTP id S264464AbTEPPn3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 16 May 2003 11:43:29 -0400
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: andmike@us.ibm.com


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Forwarded message from Alan Stern <stern@rowland.harvard.edu> -----

> Subject: Re: [linux-usb-devel] USB Storage oops in 2.5.69-bk8
> From: Alan Stern <stern@rowland.harvard.edu>
> To: Florin Iucha <florin@iucha.net>
> Cc: USB development list <linux-usb-devel@lists.sourceforge.net>
> Date: Fri, 16 May 2003 11:49:00 -0400 (EDT)
>=20
> On Thu, 15 May 2003, Florin Iucha wrote:
>=20
> > Hello,
> >=20
> > I get the following oops in 2.5.69-bk8 when I try to mount a Compact
> > Flash card in a SanDisk adapter:
> >=20
> > usb 2-1: USB disconnect, address 2
> > hub 2-0:0: debounce: port 1: delay 100ms stable 4 status 0x301
> > hub 2-0:0: new USB device on port 1, assigned address 3
> > input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse? Explorer]=
 on usb-00:02.3-1
> > usb 2-1: USB disconnect, address 3
> > drivers/usb/input/hid-core.c: can't resubmit intr, 00:02.3-1/input0, st=
atus -19
> > hub 2-0:0: debounce: port 1: delay 100ms stable 4 status 0x301
> > hub 2-0:0: new USB device on port 1, assigned address 4
> > input: USB HID v1.00 Mouse [Microsoft Microsoft IntelliMouse? Explorer]=
 on usb-00:02.3-1
> > SCSI device sda: 31232 512-byte hdwr sectors (16 MB)
> > sda: Write Protect is off
> > sda: Mode Sense: 02 00 00 00
> > drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> > drivers/usb/core/message.c: usb_control/bulk_msg: timeout
> > drivers/usb/core/hub.c: USB device not accepting new address (error=3D-=
22)
> > scsi: Device offlined - not ready after error recovery: host 1 channel =
0 id 0 lun 0
> > usb 5-2: USB disconnect, address 2
> > Unable to handle kernel paging request at virtual address 544150a8
> >  printing eip:
> > c02abc39
> > *pde =3D 00000000
> > Oops: 0000 [#1]
> > CPU:    0
> > EIP:    0060:[<c02abc39>]    Not tainted
> > EFLAGS: 00010286
> > EIP is at scsi_eh_finish_cmd+0x19/0x60
> > eax: ef19d000   ebx: eef28080   ecx: eef22140   edx: 54415056
> > esi: eef21fa8   edi: eef21fb0   ebp: eef21fa8   esp: eef21f60
> > ds: 007b   es: 007b   ss: 0068
> > Process scsi_eh_1 (pid: 118, threadinfo=3Deef20000 task=3Deef23340)
> > Stack: eef28080 eef28080 eef21fb0 c02ac418 eef28080 eef21fa8 00000000 0=
0000000=20
> >        00000000 ef62f428 eef20000 00000282 eef21fa8 c02ac8d6 eef21fb0 e=
ef21fa8=20
> >        eef21fa8 eef21fb0 eef21fa8 eef21fa8 eef28098 eef28098 ef62f400 e=
ef21fd4=20
> > Call Trace:
> >  [<c02ac418>] scsi_eh_offline_sdevs+0x68/0x80
> >  [<c02ac8d6>] scsi_unjam_host+0xc6/0xd0
> >  [<c02ac9b1>] scsi_error_handler+0xd1/0x120
> >  [<c02ac8e0>] scsi_error_handler+0x0/0x120
> >  [<c0108abd>] kernel_thread_helper+0x5/0x18
> >=20
> > Code: 0f b7 42 52 48 66 89 42 52 c7 43 24 00 00 00 00 66 c7 43 08=20
> >=20
> > I cannot tell if it is a regression since I just got the CF and the
> > adapter.
>=20
> This is a problem in the SCSI error handler.  You should post your=20
> question to <linux-scsi@vger.kernel.org>.  Maybe also cc: to Mike Anderso=
n=20
> <andmike@us.ibm.com>.
>=20
> Alan Stern

----- End forwarded message -----

florin

--=20

"NT is to UNIX what a doughnut is to a particle accelerator."

--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQE+xQolNLPgdTuQ3+QRAmFMAKCR5XkkXqcBZbrCYTrm3fAfgYL5CACdGzZ6
k5cHGJTC2HLNyTCFhf40Cso=
=ByYV
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
