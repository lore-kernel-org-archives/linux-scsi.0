From: Thomas Maguin <T.Maguin@web.de>
Subject: cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer.
Date: Thu, 12 Jan 2006 13:21:58 +0100
Message-ID: <200601121322.17458.T.Maguin@web.de>
Reply-To: T.Maguin@web.de
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1350528.fo6dNcjT89";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp08.web.de ([217.72.192.226]:43444 "EHLO smtp08.web.de")
	by vger.kernel.org with ESMTP id S1030321AbWALMVj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 07:21:39 -0500
Received: from [80.136.198.71] (helo=paris.troja)
	by smtp08.web.de with asmtp (TLSv1:AES256-SHA:256)
	(WEB.DE 4.105 #340)
	id 1Ex1ST-0005Qk-00
	for linux-scsi@vger.kernel.org; Thu, 12 Jan 2006 13:21:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart1350528.fo6dNcjT89
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

cdrecord 2.01.01_alpha04 without any patches is working fine as root.

As user  cdrecord dev=3DATA:1,0,0 blank=3Dfast  results in:
cdrecord: Cannot allocate memory. Cannot get SCSI I/O buffer

The user is in group burning, the rights are set as with 2.01.01_alpha01,=20
where user burning was possible. kernel is 2.6.14-nitro2.

=2D-=20

=2D------------------------------------------
protect your privacy - encrypt your mails
my key is: 0x2AA933B6

--nextPart1350528.fo6dNcjT89
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBDxkn5yat6ziqpM7YRApcEAKCVX4Pb4csdvaAYMYX88BHq0CGvQwCffXhW
qDs+nQH4sdqT45em/ebD/+U=
=fyaX
-----END PGP SIGNATURE-----

--nextPart1350528.fo6dNcjT89--
