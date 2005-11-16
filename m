From: Steve McIntyre <steve@einval.com>
Subject: Re: cdrecord and newer Linux kernels
Date: Wed, 16 Nov 2005 12:30:47 +0000
Message-ID: <20051116123047.GA4092@einval.com>
References: <20051111000913.GU4682@einval.com> <20051116033903.07B1234031@koto.vergenet.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3MwIy2ne0vdjdPXF"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lump.einval.com ([217.147.81.17]:36110 "EHLO mail.einval.com")
	by vger.kernel.org with ESMTP id S1030304AbVKPMbl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 07:31:41 -0500
Received: from bsmtp by mail.einval.com with local-bsmtp (Exim 3.36 #1 (Debian))
	id 1EcMRc-0002J2-00
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 12:31:20 +0000
Content-Disposition: inline
In-Reply-To: <20051116033903.07B1234031@koto.vergenet.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Horms <horms@verge.net.au>
Cc: debian-kernel@lists.debian.org, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org


--3MwIy2ne0vdjdPXF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16, 2005 at 12:39:03PM +0900, Horms wrote:
>In article <20051111000913.GU4682@einval.com> you wrote:
>>=20
>> That does make it rather difficult to have any safe CD/DVD writing
>> software - do you think it's a good idea to have end users run apps as
>> root to burn CDs? I've read too much of the cdrecord source to be
>> happy running that as root! :-) My thought is that it might be better
>> to allow specific commands on specific drives, and let the local admin
>> configure that for themselves...
>>=20
>
>The whole problem is that some IOCTLS are not safe. And there is no
>definitive list of IOCTLs, so safe ones are added as they are known. And
>the others are disabled.  If you have discovered ioctls which are indeed
>safe, then they should be added to the whitelist.
>
>As for allowing root to have a mechanism to allow users to access
>arbitary (unsafe) ioctls, that sounds like a can of worms to me.
>I have CCed the SCSI maintainers for comment.
>
>For their reference, your original post and patch, allong with
>the rest of this thread is at:
>
>http://lists.debian.org/debian-kernel/2005/11/msg00748.html

Again, I understand why the checks were added to the kernel. Adding
access controls to limit the damage that could be caused by non-root
users is entirely a good plan!

The reason I'm looking into this is that there are some commands that
may be dangerous on some devices but on others harmless / useful /
required (even); several years of writing SCSI-based storage
management software has show me that. :-) Allowing a mechanism for an
admin to override the in-kernel policy on a per-device, per-command
basis could allow us to safely allow non-root CD/DVD burning, I hope.

--=20
Steve McIntyre, Cambridge, UK.                                steve@einval.=
com
Google-bait:
  Debian does NOT ship free CDs. Please do NOT contact the mailing
  lists asking us to send them to you.

--3MwIy2ne0vdjdPXF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFDeyZ3fDt5cIjHwfcRAhfuAJ0TtKH4k0Wq0nB89g+1MI0buhpQRwCghizY
EkmHDqFpoivgEpl0tVIvdrw=
=5f+C
-----END PGP SIGNATURE-----

--3MwIy2ne0vdjdPXF--

