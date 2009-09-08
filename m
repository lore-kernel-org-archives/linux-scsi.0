From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: be2iscsi driver
Date: Tue, 8 Sep 2009 20:06:04 +1000
Message-ID: <20090908200604.beb14288.sfr@canb.auug.org.au>
References: <20090908083546.GA19467@serverengines.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Sep_2009_20_06_04_+1000_qSO5LEv_7LspN1yL"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from chilli.pcug.org.au ([203.10.76.44]:34918 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753902AbZIHKGJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Sep 2009 06:06:09 -0400
In-Reply-To: <20090908083546.GA19467@serverengines.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kalickal <jayamohank@serverengines.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, michaelc@cs.wisc.edu

--Signature=_Tue__8_Sep_2009_20_06_04_+1000_qSO5LEv_7LspN1yL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jayamohan,

On Tue, 8 Sep 2009 14:05:58 +0530 Jayamohan Kallickal <jayamohank@servereng=
ines.com> wrote:
>
>    This patch contains  a fix for powerpc compile issue  and has
>     been tested for compile on powerpc with allyesconfig option.=09

Thanks for that.

>   The series of  patches are described below:

This series should be applied in an order that allows the kernel as a
whole to keep building at each step.  The easiest way to guarantee that
would be to put your patch 1 as the last one.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Sep_2009_20_06_04_+1000_qSO5LEv_7LspN1yL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqmLIwACgkQjjKRsyhoI8xtsgCfYEF9ygtlCyAOEUyG4a1qHrLK
8akAniAsgewb/v82N1digdbbDp31pAjC
=V+WJ
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Sep_2009_20_06_04_+1000_qSO5LEv_7LspN1yL--
