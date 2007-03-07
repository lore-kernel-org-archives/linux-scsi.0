From: Joerg Dorchain <joerg@dorchain.net>
Subject: Re: [stable] [patch 29/29] bug in gdth.c crashing machine
Date: Wed, 7 Mar 2007 21:05:54 +0100
Message-ID: <20070307200554.GQ3250@Redstar.dorchain.net>
References: <200703061046.l26AksTi020093@shell0.pdx.osdl.net> <1173288505.3771.33.camel@mulgrave.il.steeleye.com> <20070307174021.GA25066@kroah.com> <20070307111616.16e5e641.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JZZUlh2R5zuJqba0"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from RedStar.dorchain.net ([212.88.133.153]:46077 "EHLO
	Redstar.dorchain.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965629AbXCGU2X (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Mar 2007 15:28:23 -0500
Content-Disposition: inline
In-Reply-To: <20070307111616.16e5e641.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@SteelEye.com>, rdunlap@xenotime.net, Achim_Leubner@adaptec.com, joerg@dorchain.net, stable@kernel.org, linux-scsi@vger.kernel.org


--JZZUlh2R5zuJqba0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2007 at 11:16:16AM -0800, Andrew Morton wrote:
> > On Wed, Mar 07, 2007 at 11:28:25AM -0600, James Bottomley wrote:
> > > On Tue, 2007-03-06 at 02:46 -0800, akpm@linux-foundation.org wrote:
> > > > From: Joerg Dorchain <joerg@dorchain.net>
> > > >=20
> > > > Undocumented...
> > >=20
> > > This is a bit of a problem, isn't it?
> > >=20
> > > I have no report of any problem this fixes, and no input from the gdth
> > > maintainer about this.  The first I actually knew of this patch reque=
st
> > > is that it appeared in an akpm patch stream yesterday.
> > >=20
> > > I really think we need more details before this gets applied to
> > > anything, let alone the stable tree.
> >=20
> > Randy did forward it to the stable team a while ago too, but I didn't
> > know even what tree it applied to as the patch level was a bit off.  I
> > think he might have some more information about it?
> >=20
>=20
> Achim did reply:  http://lkml.org/lkml/2007/2/23/138

The current gdth driver crashes the machine with a panic() when
accessing certain tape drives, really not a good thing for stable.

This patch fixes it, tested by me and acknowledged by Achim.
See http://lkml.org/lkml/2006/10/13/60 and
http://lkml.org/lkml/2006/10/12/35 for further reference.

The patch is against Linus' 2.6.20

Bye,

Joerg

--JZZUlh2R5zuJqba0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF7xsijY4+4PdzvOARAjr/AJ9XarMAfBCPmGM1iX7ZElBZe/OuGQCfZzfR
oAkbPTxwMGeUpE3Zg/onrSo=
=/n80
-----END PGP SIGNATURE-----

--JZZUlh2R5zuJqba0--
