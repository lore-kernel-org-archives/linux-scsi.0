From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] unique_id for ide-scsi
Date: Mon, 9 Feb 2004 17:19:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040209161904.GU3944@tpkurt.garloff.de>
References: <20040209155440.GQ3944@tpkurt.garloff.de> <20040209160605.B23604@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i6WX/W6h5xa4jqsd"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:64441 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S265212AbUBIQUZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Feb 2004 11:20:25 -0500
Content-Disposition: inline
In-Reply-To: <20040209160605.B23604@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>


--i6WX/W6h5xa4jqsd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Mon, Feb 09, 2004 at 04:06:05PM +0000, Christoph Hellwig wrote:
> > Caveats: It puts the first PATA port there, the SATA port are not
> >  considered. Are there SATA chips that don't have PATA ports?
>=20
> What do you need this for?  I'd prefer to completly nuke unique_id in
> 2.7.<early>

You have two scsi host adapters of one kind and want to identify the
path to them. For non-enumerated buses (like ISA), the unique_id is=20
useful.=20

Regards,
--=20
Kurt Garloff                   <kurt@garloff.de>             [Koeln, DE]
Physics:Plasma modeling <garloff@plasimo.phys.tue.nl> [TU Eindhoven, NL]
Linux: SUSE Labs (Head)        <garloff@suse.de>    [SUSE Nuernberg, DE]

--i6WX/W6h5xa4jqsd
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.3 (GNU/Linux)

iD8DBQFAJ7L3xmLh6hyYd04RAnJFAJ0fVbHXjdNK77AlLQJyx8FwCehmxgCgnlMy
Oh+QNSjXovgqMOMoCfgW3CE=
=cSs6
-----END PGP SIGNATURE-----

--i6WX/W6h5xa4jqsd--
