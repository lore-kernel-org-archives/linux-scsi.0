From: Rolf Eike Beer <eike@sf-mail.de>
Subject: Re: [PATCH 2/2] be2iscsi: Fixing the /proc/interrupts problem V3
Date: Tue, 12 Jul 2011 21:24:45 +0200
Message-ID: <201107122124.53323.eike@sf-mail.de>
References: <1310490756-2210-1-git-send-email-jayamohan.kallickal@emulex.com> <894955a8-23e3-4553-bfb5-614b2bc8ed93@exht1.ad.emulex.com> <1310491313.16900.12.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2975146.z3lCfzmtN6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:39453 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab1GLTZE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jul 2011 15:25:04 -0400
In-Reply-To: <1310491313.16900.12.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: jayamohan.kallickal@emulex.com, linux-scsi@vger.kernel.org, michaelc@cs.wisc.edu, Prarit Bhargava <prarit@redhat.com>

--nextPart2975146.z3lCfzmtN6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Dienstag 12 Juli 2011, 19:21:52 schrieb James Bottomley:
> On Tue, 2011-07-12 at 10:12 -0700, jayamohan.kallickal@emulex.com wrote:
> > From: Jayamohan Kallickal <jayamohan.kallickal@emulex.com>
> >=20
> > This patch is based on one by Prarit Bhargava. I have made minor
> > changes. Also, removed the redundant check for i =3D=3D 0 and adding
> > changelog  as suggested by Rolf.
>=20
> This changelog doesn't actually say what the patch does.  From the
> description, it sounds like a stable candidate, but I can't really tell.
>=20
> Please send an actual description including what the problem was and
> what was done to fix it.  What's above can be the last paragraph
> recording the patch history.

When you change the text anyway write "Eike".

Thx,

Eike

--nextPart2975146.z3lCfzmtN6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEUEABECAAYFAk4cn4UACgkQXKSJPmm5/E5XdACeKHmgqoQyOQ1IbpKMHPhPLUEj
UzIAli5lc/z0OSK6DCFTBAGupZG28Qs=
=YV2C
-----END PGP SIGNATURE-----

--nextPart2975146.z3lCfzmtN6--
