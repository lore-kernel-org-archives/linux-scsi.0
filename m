From: Mike Bursell <mike@hingston.demon.co.uk>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from
	emulated SCSI hosts
Date: 22 Apr 2003 18:34:33 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1051032873.3737.2.camel@lemon.hingston>
References: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FJCD6FWUY1suufz+xuNR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from anchor-post-35.mail.demon.net ([194.217.242.85]:53654 "EHLO
	anchor-post-35.mail.demon.net") by vger.kernel.org with ESMTP
	id S263234AbTDVRWK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 13:22:10 -0400
In-Reply-To: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mdharm-scsi@one-eyed-alien.net, torvalds@transmeta.com, usb-storage@one-eyed-alien.net


--=-FJCD6FWUY1suufz+xuNR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi -

I'm not sure if I'm the first or second bugzilla report (I'm 553 -
what's the other one?), but I don't have a log for 2.4.*, and I suspect
that the changes I've made to my machine since I moved to the 2.5 series
full-time will mean that I can't boot up sensibly in 2.4.* anymore.=20
Anything else I could help with, though?

-Mike.


On Tue, 2003-04-22 at 18:22, Andries.Brouwer@cwi.nl wrote:
> Then we get the second bugzilla report. Interesting.
> It fails in precisely the same way as the first one:
>=20
>=20
> Apr  9 17:34:55 lemon: SCSI device sda: 126848 512-byte hdwr sectors (65 =
MB)
> Apr  9 17:34:55 lemon: usb-storage: queuecommand() called
> Apr  9 17:34:55 lemon: usb-storage: *** thread awakened.
> Apr  9 17:34:55 lemon: usb-storage: Command MODE_SENSE (6 bytes)
> Apr  9 17:34:55 lemon: usb-storage:  1a 00 3f 00 04 00
> Apr  9 17:34:55 lemon: usb-storage: Invoking Mode Translation
> Apr  9 17:34:55 lemon: usb-storage: usb_stor_ctrl_transfer(): rq=3D00 rqt=
ype=3D21 value=3D0000 index=3D00 len=3D12
> Apr  9 17:34:55 lemon: usb-storage: Status code 0; transferred 12/12
> Apr  9 17:34:55 lemon: usb-storage: -- transfer complete
> Apr  9 17:34:55 lemon: usb-storage: Call to usb_stor_ctrl_transfer() retu=
rned 0
> Apr  9 17:34:55 lemon: usb-storage: usb_stor_bulk_transfer_buf(): xfer 4 =
bytes
> Apr  9 17:34:55 lemon: usb-storage: Status code -75; transferred 4/4
> Apr  9 17:34:55 lemon: usb-storage: -- unknown error
> Apr  9 17:34:55 lemon: usb-storage: CB data stage result is 0x3
> Apr  9 17:34:55 lemon: usb-storage: -- transport indicates error, resetti=
ng
> Apr  9 17:34:55 lemon: usb-storage: CB_reset() called
> Apr  9 17:35:11 lemon modprobe: FATAL: Module /dev/tts/64 not found.=20
> Apr  9 17:35:15 lemon: drivers/usb/core/message.c: usb_control/bulk_msg: =
timeout
> Apr  9 17:35:25 lemon: usb-storage: command_abort() called
> Apr  9 17:35:25 lemon: usb-storage: usb_stor_abort_transport called
>=20
>=20
> But here the additional information is:
> It was working fine under 2.4.* but under 2.5.66/67 it hangs.
>=20
> Is there a problem with MODE_SENSE? But 2.4 also does this MODE_SENSE.
> A first step is perhaps finding out what the * is for.
>=20
> Which 2.4 versions are known to work correctly?
>=20
> Andries
>=20
> [And is there a verbose usb-storage log on a successful 2.4?]
--=20
07050 144575 mike@hingston.demon.co.uk

--=-FJCD6FWUY1suufz+xuNR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQA+pX0pj6h57cc9oOkRAq83AKCINO208Xja9LWTNRoxWF68Upp9oACffPGe
uc3kubhYp5TH01glmRFIJtQ=
=Yhj/
-----END PGP SIGNATURE-----

--=-FJCD6FWUY1suufz+xuNR--

