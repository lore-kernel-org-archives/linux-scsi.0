From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
Subject: Re: [usb-storage] Re: External USB3 disk fails with "Invalid field
 in cdb"
Date: Mon, 30 Jun 2014 15:55:52 +0200
Message-ID: <20140630155552.2070857b@wiggum>
References: <20140627205153.6a8ac916@wiggum>
	<Pine.LNX.4.44L0.1406271521350.875-100000@iolanthe.rowland.org>
	<20140627215235.4be63476@wiggum>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/KZiWaE+2fQ2scpE4+qaWgcr"; protocol="application/pgp-signature"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:50564 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751409AbaF3N4f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 30 Jun 2014 09:56:35 -0400
In-Reply-To: <20140627215235.4be63476@wiggum>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Bryn M. Reeves" <bmr@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>, USB Storage list <usb-storage@lists.one-eyed-alien.net>

--Sig_/KZiWaE+2fQ2scpE4+qaWgcr
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jun 2014 21:52:35 +0200
Michael B=C3=BCsch <m@bues.ch> wrote:

> On Fri, 27 Jun 2014 15:23:42 -0400 (EDT)
> Alan Stern <stern@rowland.harvard.edu> wrote:
> > Does the patch below do what you and James want?
>=20
> Yes, this does work. Thanks!
>=20
> You can add my
> Tested-by: Michael B=C3=BCsch <m@bues.ch>


Does somebody pick this up for inclusion?
It'd also be good, if this hit stable.


--=20
Michael

--Sig_/KZiWaE+2fQ2scpE4+qaWgcr
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBAgAGBQJTsWxrAAoJEPUyvh2QjYsOcRkQAKqOix+6C33Emtd+RtPU5Kru
89og51fiAdHmQY6HlJb2AGLTNUh9KN0WZbYj7ElAHwwcWQQqY6qmnpROlCPehafg
vDwe11FuERc3ErB5ov7MsP1qiQgOAkLMxP9W7AAFz87g0/6vrbzZNBppwVj5HVPF
xRRfdlIlYr7zpMlV54W178yPp6BlrwDYI6reNeEYTsinzmeXwve1o4NSWQ7ZSEu6
0qmtC+M2IrlA4+0yoa8bDGUK8VlthmlgQlG4zbHpXj2KstxeXZwsjgb4i5E1IA/+
VCfvnOY5YUC7vAu+B6Lmxy7IE5u3DGhb440+0IBp8DIdPebZkqyTOM1rqrxDiLUO
QzbOwHVD6rbgJKg8PZsyu6h0rrmBRpYrFFWa29yYFf8wRXSmFAlp0XKrQfQlCeEt
QI+OBQQTPE0fm7WH4SqClpFfIXwO3Vxm0ooCHE9jIx7EevpYvNgSpWCZimDxIpRJ
aZp77sOTt7deO/cpH1uawtHrLflGnpAZjj7HOVwiOqYp3VBsU0lW6NEDD6CW2BN+
cjujhKl1nIg52PIqvq0eIBQtW5ZjCt/xHePzg2tcnmezdoiF4LMfDlPNFb1dM45S
9tPRn6V75V2vVSQxoJuWHoY2NtlgajyX0RuWqRmPzvEPxoPc1s+uXEX4s/4ZXpg7
QreRORBQXG33njz7LwJH
=NOTd
-----END PGP SIGNATURE-----

--Sig_/KZiWaE+2fQ2scpE4+qaWgcr--
