From: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Subject: Re: [usb-storage] Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Tue, 22 Apr 2003 11:50:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030422115017.B31829@one-eyed-alien.net>
References: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-md5;
	protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ziggy.one-eyed-alien.net ([64.169.228.100]:61710 "EHLO
	ziggy.one-eyed-alien.net") by vger.kernel.org with ESMTP
	id S263343AbTDVSiS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Apr 2003 14:38:18 -0400
Content-Disposition: inline
In-Reply-To: <UTC200304221722.h3MHMBL16595.aeb@smtp.cwi.nl>; from Andries.Brouwer@cwi.nl on Tue, Apr 22, 2003 at 07:22:11PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Andries.Brouwer@cwi.nl
Cc: James.Bottomley@steeleye.com, alan@lxorguk.ukuu.org.uk, greg@kroah.com, linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net, mike@hingston.demon.co.uk, torvalds@transmeta.com, usb-storage@one-eyed-alien.net


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 22, 2003 at 07:22:11PM +0200, Andries.Brouwer@cwi.nl wrote:
> Then we get the second bugzilla report. Interesting.
> It fails in precisely the same way as the first one:
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
> But here the additional information is:
> It was working fine under 2.4.* but under 2.5.66/67 it hangs.
>=20
> Is there a problem with MODE_SENSE? But 2.4 also does this MODE_SENSE.
> A first step is perhaps finding out what the * is for.

2.4 does a MODE_SENSE, but does it differently.

> Which 2.4 versions are known to work correctly?

That depends on the particular device in question.

> [And is there a verbose usb-storage log on a successful 2.4?]

Yes.

Matt

--=20
Matthew Dharm                              Home: mdharm-usb@one-eyed-alien.=
net=20
Maintainer, Linux USB Mass Storage Driver

Umm, these aren't the droids you're looking for.
					-- Bill Gates
User Friendly, 11/14/1998

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: For info see http://www.gnupg.org

iD8DBQE+pY7pIjReC7bSPZARAmbTAJ0ScM1xiKLLa0m44vTY9YA26l2OmgCgpV9l
ApfzKoo1TxMBzOtwcul1li0=
=0cQb
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
