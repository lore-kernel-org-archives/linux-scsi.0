From: "Verma, Vishal L" <vishal.l.verma@intel.com>
Subject: Re: [PATCH v2 1/3] badblocks: Add core badblock management code
Date: Tue, 8 Dec 2015 21:08:23 +0000
Message-ID: <1449608892.16905.121.camel@intel.com>
References: <1448477013-9174-1-git-send-email-vishal.l.verma@intel.com>
	 <1448477013-9174-2-git-send-email-vishal.l.verma@intel.com>
	 <1449271801.27077.25.camel@HansenPartnership.com>
	 <1449273524.16905.103.camel@intel.com>
	 <87egewslfa.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="=-TaYFe6AU+soyNM+S2HZb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:21654 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804AbbLHVIZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 8 Dec 2015 16:08:25 -0500
In-Reply-To: <87egewslfa.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "neilb@suse.com" <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "jmoyer@redhat.com" <jmoyer@redhat.com>, "axboe@fb.com" <axboe@fb.com>

--=-TaYFe6AU+soyNM+S2HZb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2015-12-09 at 08:03 +1100, NeilBrown wrote:
> On Sat, Dec 05 2015, Verma, Vishal L wrote:
> > >=20
> > > > +int badblocks_clear(struct badblocks *bb, sector_t s, int
> > > > sectors)
> > > > +{
> > > [...]
> > > > +#define DO_DEBUG 1
> > >=20
> > > Why have this at all if it's unconditionally defined and always
> > > set.
> >=20
> > Neil - any reason or anything you had in mind for this? Or is it
> > just an
> > artifact and can be removed.
>=20
> Like the comment says:
>=20
> 	/* Allow clearing via sysfs *only* for testing/debugging.
> 	 * Normally only a successful write may clear a badblock
> 	 */
>=20
> The DO_DEBUG define and ifdefs are documentation identifying bits of
> code that should be removed when it all seems to be working.
> Maybe now is a good time to remove that code.
>=20
Hm, I think it would be nice to continue to have the ability to clear
badblocks using sysfs at least for a while more, as we test the various
error handling paths for NVDIMMS (Dan, thoughts?).

We could either remove it later or (I'm leaning towards) make it a
config option similar to FAIL_MAKE_REQUEST and friends..

	-Vishal
--=-TaYFe6AU+soyNM+S2HZb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAABAgAGBQJWZ0a8AAoJEHr6Yb6juE3/GxwP/juOHdbvM72xOojAM2M1FHuu
Fc/kJJmHtERB1t+1efb5vB23F0ljp1A2O42IZt3ke+4GqiLk5MKc+4gotSTKMBz3
O0jQAj8u43PDSTWYWetK/B/8JQiKen81UQK9JNs5W9h2nb1vXX8eFAwgOW8CCqjV
SegQ6Vd2hcs55SiAZdvQvYGkdTiYy8O/cH3+rkoWd6ikKL+hbeunK8yRh6hv9A7s
ZBrTsHHCFiu+buzFwZCIhl6oyZ0AltBvLa6vNVE2xHqP8wJBZ6Dmi7MzPjl1Ij1g
RwdNyNCoyIuUu8OjBm7c4vJWdX5fL9Exl4pXD9ZrLTOAjTrX1cVPaZoHSxBQXGGA
qFHyenJW0Jj5t8SGGNxwfeWu6qs+Y1joNT2K/q8oHdMtOgc5OqxQ187PMG2J6CQ5
p+sNnzAOS9j7AYptA19rNocK61XTf/yM2eMs4odGuJrVWqUkNIr9lcEbOd7Bxoqi
bOOUflMbg2JnvjVWm/yyZ6KUr8W7VOe8THrdiMTpXxsorGcr+ZbKzWEbdAePuSSt
YPJS1rdueQiasYcQm89t+u9U/IIfJB+H7aARcjyq2xmaoBlmxykCLVMuA8jfGYX+
a1eufbmYZ1fwNlnz9GTEGPt1xXvvbiWKZJ09bZrTiKENX8/mCjHUaat+VNL11WOt
gbEokXfz/1pXWHaXO49d
=91Y2
-----END PGP SIGNATURE-----

--=-TaYFe6AU+soyNM+S2HZb--
