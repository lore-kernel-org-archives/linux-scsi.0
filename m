From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 2.6.3 qla2xxx driver -- use readX_relaxed
Date: Thu, 26 Feb 2004 09:52:30 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1077785550.4443.0.camel@laptop.fenrus.com>
References: <20040226040535.GA559454@sgi.com>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jLAfBIZPTcrDKeRkEdKk"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from node-d-1fcf.a2000.nl ([62.195.31.207]:44160 "EHLO
	laptop.fenrus.com") by vger.kernel.org with ESMTP id S262747AbUBZIwx
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Feb 2004 03:52:53 -0500
In-Reply-To: <20040226040535.GA559454@sgi.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeremy Higdon <jeremy@sgi.com>
Cc: linux-scsi@vger.kernel.org, jbarnes@cthulhu.engr.sgi.com


--=-jLAfBIZPTcrDKeRkEdKk
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2004-02-26 at 05:05, Jeremy Higdon wrote:
> I'm submitting a patch for comment and consideration.  The relaxed read
> interface was added a few weeks back, and this patch lets the qla2xxx dri=
ver
> take advantage of it.

please tell me we don't have to pee all over the drivers to add this
everywhere now;(


--=-jLAfBIZPTcrDKeRkEdKk
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAPbPOxULwo51rQBIRAgPCAJ4jqx7Hza6wX8D+/olO+6nZS/+vaACeIgK/
PUEMNec67ZIKpW2I7cDWSeY=
=hAds
-----END PGP SIGNATURE-----

--=-jLAfBIZPTcrDKeRkEdKk--
