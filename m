From: "Ian P. Christian" <pookey@pookey.co.uk>
Subject: Re: Strange problems with a Megaraid RAID array on a Dell Poweredge 1850
Date: Thu, 8 Dec 2005 16:40:16 +0000
Message-ID: <200512081640.17092.pookey@pookey.co.uk>
References: <200512080118.17001.pookey@pookey.co.uk>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4931175.41IXUVzyfI";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from xian.ncuk.net ([80.249.110.212]:53432 "EHLO xian.ncuk.net")
	by vger.kernel.org with ESMTP id S932206AbVLHQkU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2005 11:40:20 -0500
In-Reply-To: <200512080118.17001.pookey@pookey.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

--nextPart4931175.41IXUVzyfI
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 08 December 2005 01:18, Ian P. Christian wrote:
> I'm having an odd problem with a poweredge 1850, and it's driving me mad -
> google's not helped me, I've tried a few mailing lists, and I've run out =
of
> places to look, so any help would be greatly appreciated.
>
> Basically, I can't use fdisk on /dev/sda.  I can however boot off this
> array, and everything is working fine - I'm having no issues using this
> array for anything else. A live, and apparently healthy system is running
> from it.

Problem solved - was a bug in fdisk, upgrading or downgrading from 12r fixe=
d=20
the problem.

Kind Regards,

=2D-=20
Ian P. Christian ~ http://pookey.co.uk

--nextPart4931175.41IXUVzyfI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQBDmGHx6jsuvK/fgkoRAlFZAKCbGz7j9rZfNUVHAeXhWm4MVJu5EACeIUvK
VHrhd2MRKuRBLGTDWQnCIlU=
=rZrq
-----END PGP SIGNATURE-----

--nextPart4931175.41IXUVzyfI--
