From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] Re: AMD 53c974 SCSI driver in 2.6
Date: Wed, 19 Nov 2003 16:34:38 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031119153437.GA2115@tpkurt.garloff.de>
References: <20031118092844.GA2995@tpkurt.garloff.de> <Pine.LNX.4.44.0311182339460.3405-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:23173 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263891AbTKSQIa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 11:08:30 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311182339460.3405-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: "Randy.Dunlap" <rddunlap@osdl.org>, hch@infradead.org, linux-scsi@vger.kernel.org, gl@dsa-ac.de


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 19, 2003 at 12:07:06AM +0100, Guennadi Liakhovetski wrote:
> Yes, I presume, in your patch, Kurt, you meant
> -       if (pSRB->SRBFlag | AUTO_REQSENSE) {
> +       if (pSRB->SRBFlag & AUTO_REQSENSE) {
> right?

Yes, of course.
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/u42NxmLh6hyYd04RAmNtAJ9k1ZOUVpYlMkr86jPQ9Z1TZ3tifACffZx+
ka3hmKqx9E7fg+OO+ppIrPk=
=y5Pj
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
