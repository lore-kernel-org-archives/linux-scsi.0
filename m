From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH] 4/6: scsi_allow_ghost_devices
Date: Mon, 19 Apr 2004 09:34:02 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1082360042.4691.3.camel@laptop.fenrus.com>
References: <20040418185950.GG4868@tpkurt.garloff.de>
	 <20040418202022.B3393@infradead.org>
Reply-To: arjanv@redhat.com
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FNS4Omq+nxhnwZA5nzoA"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:20099 "EHLO mx2.redhat.com")
	by vger.kernel.org with ESMTP id S263614AbUDSHeX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Apr 2004 03:34:23 -0400
In-Reply-To: <20040418202022.B3393@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Kurt Garloff <garloff@suse.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@steeleye.com>, Andrew Morton <akpm@osdl.org>


--=-FNS4Omq+nxhnwZA5nzoA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> I'm very unhappy with that.  Could you explain why EMC needs this?
> And even if we have to work around it I'd rather use the blacklist mechan=
ism
> for this.

they allow the admin to config the box without a lun 0....
I 100% agree it's blacklist material.

--=-FNS4Omq+nxhnwZA5nzoA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQBAg4DpxULwo51rQBIRAl5KAJ0agkaGQTuExL6xdq00nPdao38uKgCeNh6B
vP9+GIcrGq4AmmQTWfNltCc=
=yyKt
-----END PGP SIGNATURE-----

--=-FNS4Omq+nxhnwZA5nzoA--

