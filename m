From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH, 2.6] tmscsim - no internal command-queuing
Date: Fri, 21 May 2004 01:02:33 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040520230233.GA6437@tpkurt.garloff.de>
References: <20040201111726.A14042@infradead.org> <Pine.LNX.4.44.0402032337230.3772-100000@poirot.grange> <20040219151333.A24006@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:39350 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265268AbUETXCn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 May 2004 19:02:43 -0400
Content-Disposition: inline
In-Reply-To: <20040219151333.A24006@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, linux-scsi@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Feb 19, 2004 at 03:13:33PM +0000, Christoph Hellwig wrote:
> > Ouch. Whereas the rest are either rather intelligent things I didn't kn=
ow
> > about, or something I didn't want / dare to modify without a burning ne=
ed,
> > this is definitely just a plain simple bug - I did see it was a noop, a=
nd
> > I did think at some point to preserve its consistency, until I forgot
> > about it:-)
>=20
> Kurt, do you have any opinion on those patches?  I'd love to see them goi=
ng
> in for 2.6.4

Please merge them.

--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG / Novell, Nuernberg, DE               Director SUSE Labs

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFArTkIxmLh6hyYd04RAk5TAKDKRaNytuXn6p0RI9Uwx0dI/Qwh2wCghIHz
uM45XdoLmN3Wq9Gk4M6iXPs=
=3VBv
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
