From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Subject: Re: Advansys regression between 2.6.23.8 and 2.6.24.2
Date: Thu, 14 Feb 2008 16:14:04 +0100
Message-ID: <20080214161404.5c846ad4@crazy>
References: <20080214161024.2a0c0f17@crazy>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/Zix.lxqiBSrpjSRVPa3ogLi";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.free-electrons.com ([88.191.46.45]:3792 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759365AbYBNPl1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Feb 2008 10:41:27 -0500
In-Reply-To: <20080214161024.2a0c0f17@crazy>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: matthew@wil.cx, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp
Cc: gregkh@suse.de, chrisw@sous-sol.org

--Sig_/Zix.lxqiBSrpjSRVPa3ogLi
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Le Thu, 14 Feb 2008 16:10:24 +0100,
Thomas Petazzoni <thomas.petazzoni@free-electrons.com> a =C3=A9crit :

> I have not identified which commit broke the driver, but I confirm
> that Tomonori's patch fixes the problem.

I suspect that the issue has been introduced by
d10fb2c7b5ce1b475df50cde9262d2c3fe3d296e, added in 2.6.24 by Matthew.

Sincerly,

Thomas
--=20
Thomas Petazzoni, Free Electrons
Free Embedded Linux Training Materials
on http://free-electrons.com/training
(More than 1500 pages!)

--Sig_/Zix.lxqiBSrpjSRVPa3ogLi
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHtFq89lPLMJjT96cRAr75AKC5t0iPGZTUAwGLVNhQ8H0J3x+yMQCcCs9Z
rktVCQzljeQGvW9BquIMv7U=
=+WJm
-----END PGP SIGNATURE-----

--Sig_/Zix.lxqiBSrpjSRVPa3ogLi--
