From: Kurt Garloff <garloff@suse.de>
Subject: Re: TMSCSIM [2.6] (cards)
Date: Sat, 29 Nov 2003 19:14:02 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031129181402.GM3049@tpkurt.garloff.de>
References: <3FC64CD9.8040505@yk.rim.or.jp> <Pine.LNX.4.44.0311272338560.12446-100000@poirot.grange>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2YJj5f1P6Th4nBRw"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:24711 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S263861AbTK2SOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Nov 2003 13:14:04 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0311272338560.12446-100000@poirot.grange>
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org


--2YJj5f1P6Th4nBRw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Guennadi,

On Thu, Nov 27, 2003 at 11:43:03PM +0100, Guennadi Liakhovetski wrote:
> What are the best (for testing) tmscsim-supported cards (tekram (t) /
> dawicontrol / ...)?=20

Dawi2974, TekramDC390(T), onboard 53c974/79c974 chipsets.
I doubt you can easily find new hardware with this chipset nowadays ...

> My on-board am53c974 is way too simple...=20

They are all the same ...

> Or does the
> probability of getting bugs depend of what devices hang on it?

Yep. Scanners did tend to trigger bugs in the driver in the past.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG, Nuernberg, DE                          SUSE Labs (Head)

--2YJj5f1P6Th4nBRw
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.2 (GNU/Linux)

iD8DBQE/yOHqxmLh6hyYd04RAhn8AKC/XGl6ZpG6qS1w2rcRm2Bx1kPWuwCfeoeN
iXvF4n9iKNJX1a0XgcbJkag=
=6sqK
-----END PGP SIGNATURE-----

--2YJj5f1P6Th4nBRw--
