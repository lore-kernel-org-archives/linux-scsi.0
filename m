From: Kurt Garloff <garloff@suse.de>
Subject: Re: PATCH 4/5: scsi-scan-dont-att-pq-notcon
Date: Wed, 21 Apr 2004 18:08:23 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040421160823.GK29699@tpkurt.garloff.de>
References: <20040418185751.GC4868@tpkurt.garloff.de> <1082330192.1969.37.camel@mulgrave> <20040420115419.GG4356@tpkurt.garloff.de> <1082471881.1804.34.camel@mulgrave> <20040420160334.GO4356@tpkurt.garloff.de> <20040421134511.GP28633@tpkurt.garloff.de> <20040421141417.GV28633@tpkurt.garloff.de> <20040421160257.A6793@infradead.org> <20040421152436.GD29699@tpkurt.garloff.de> <20040421163336.A7382@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ee6FjwWxuMujAVRe"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:6304 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263325AbUDUQI1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2004 12:08:27 -0400
Content-Disposition: inline
In-Reply-To: <20040421163336.A7382@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Patrick Mansfield <patmans@us.ibm.com>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--ee6FjwWxuMujAVRe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 21, 2004 at 04:33:36PM +0100, Christoph Hellwig wrote:
> On Wed, Apr 21, 2004 at 05:24:36PM +0200, Kurt Garloff wrote:
> > > Please don't duplicate it in every driver but in scsi_bus_match.  sg =
uses
> > > a completely different attachment path so it shouldn't be affected by=
 that.
> >=20
> > Is it safe to assume it will stay like this?
>=20
> Yes.  The driver model assumes to zero or one drivers per device, and to
> support sg in that world it needs to be a magic special case.

OK, that seems safe enough.

> (also needs a respin of the sd.c part of the previous patch, btw - and wh=
ile

Sure.

> you're at it can you kill the date in the scsi_scan.c comment?  Everyone =
can
> see when it was applied in bk annotate or the web interface for it)

Except that I'm not allowed to use BK. But sure, the date can go ...

But unfortunately James prefers yet another approach, where we add
a inq_pq field to struct scsi_device ...
Patrick did not like it, if I parsed his mail correctly.=20
So we've conflicting requirements.

I'll wait for this to be sorted. If it's only used at one place
(bus_match), I believe parsing it directly from the inquiry data
is perfectly fine. The code dupl in UL drivers was not.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--ee6FjwWxuMujAVRe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAhpx3xmLh6hyYd04RAlvzAJwOA9Bul+xsejmU0H7hFURp0JjHvgCfTUEP
0FXlTpyepLH1ZR/O59u+0tQ=
=oEKJ
-----END PGP SIGNATURE-----

--ee6FjwWxuMujAVRe--
