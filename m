From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: isci.git#all for linux-next
Date: Mon, 13 Feb 2012 11:24:54 +1100
Message-ID: <20120213112454.41ad83568a6cd4a9f8c2ff81@canb.auug.org.au>
References: <1328900367.27478.29.camel@ultramagnus.opencreations.com>
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__13_Feb_2012_11_24_54_+1100_B/LOEZjnwXn1H..v"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from haggis.pcug.org.au ([203.10.76.10]:58835 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754757Ab2BMAZC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Feb 2012 19:25:02 -0500
In-Reply-To: <1328900367.27478.29.camel@ultramagnus.opencreations.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org

--Signature=_Mon__13_Feb_2012_11_24_54_+1100_B/LOEZjnwXn1H..v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dan,

On Fri, 10 Feb 2012 10:59:25 -0800 Dan Williams <dan.j.williams@intel.com> =
wrote:
>
> I have a couple of active topic branches brewing for 3.4 that address
> problems in libsas as well as ongoing development of the libsas-based
> isci driver.  They are at the point where they should be getting
> exposure in -next, so I have combined them into a daily-merge branch
> 'all' for linux-next consumption.
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/djbw/isci.git all

I have added this from today.

> For at least the next few weeks I would like to have this tree in -next.
> This gives James the option of letting these brew with -next exposure
> before applying the patches, or just pulling the git topics directly for
> the merge window.  If this tree ever develops a conflict with scsi-misc
> -next should drop it as that probably means the patches have started
> making their way into scsi-misc.

I try my best to not drop trees because that will screw up Andrew's work,
if nothing else.  And with any luck, James will actually merge your
branches rather than apply your patches and thus we will get no
conflicts ...

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Mon__13_Feb_2012_11_24_54_+1100_B/LOEZjnwXn1H..v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPOFhWAAoJEECxmPOUX5FEVR0P/2HuuWOUP0ckRris7RBjig2q
6tuk0zLb2kV25ppFHE2sSW8mWY49mpmJe04GTe80RDMaH6+DRUtKNiNN7RiNE0hA
wm2YfWzTsZJ9pA4PNwap5KYtII54XNBEMsQJU6FrrnNojrpk22QkLpbrF13Y76Mt
jRwWxTqN5MR3zpMX4xolIpfEJGwjdHNTmiGQdbeF7ljU5mZ32UFlMqVMI2Q22bN8
AJYFYdKBqJP3QyGPieXNd+Yjr/i47BYaoEKZm0IRaXFomFe89yCUH6/KJWELjo7F
r1oSe0qvsTKoBLOf5zlgcTSNm8cj439syO433SUSBqkV2RHdCcA+vgMEMytAkaZR
hinqCJkXTd5K1vFcWgaFx4Zn3VNhAdMNNfUH2XaUAbChqa5GH0r3gtUHf5FqPzpL
Mxsp+5KrknllnouGOMnFR489Jw5/DRDYz/I4gV7tFdlEzRRo7+fEhNy5+73dB9Pu
r5F+bGdrPm1y/Q8x+vF3gwK8kWg5c6YMtask+Ydq1UprEHIB9ags2tOiDF4f23+h
wY3x1bIJ4UQvILjMzQhjEi2Dcw1x+jEOhcOdEasDHTdr4WEOX8+J6OzLEXFDqsHE
dk5UJgsyHLV7byP2DPANrif76QYhcoRTgijTesjHmcxTcp3OBgzdOSSe2oy4hzNU
NILoVs5vzhukHA+SSFOM
=001m
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Feb_2012_11_24_54_+1100_B/LOEZjnwXn1H..v--
