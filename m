From: Kurt Garloff <garloff@suse.de>
Subject: Re: [PATCH] tmscsim: 64-bit cleanup
Date: Sat, 22 May 2004 10:09:24 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040522080924.GP4623@tpkurt.garloff.de>
References: <Pine.LNX.4.44.0405192135160.6790-200000@poirot.grange> <1085152512.2258.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tZCmRiovzb4sxAVa"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51172 "EHLO Cantor.suse.de")
	by vger.kernel.org with ESMTP id S264909AbUEVIJ3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 May 2004 04:09:29 -0400
Content-Disposition: inline
In-Reply-To: <1085152512.2258.21.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>, Linux SCSI list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>


--tZCmRiovzb4sxAVa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James, Guennadi,

On Fri, May 21, 2004 at 10:15:11AM -0500, James Bottomley wrote:
> On Wed, 2004-05-19 at 14:50, Guennadi Liakhovetski wrote:
> Actually, no.  struct scatterlist is for the OS platform to use to
> characterise DMA; it's actually a private structure entirely within the
> gift of the architecture to define.  It usually contains bits of
> extraneous data that the driver never sees.  The driver should convert
> struct scatterlist into its own version of the scatterlist that needs
> feeding to the hardware rather than try and use struct scatterlist.

The AM53C974 hardware does not have hardware support for scatter-gather.
(Yes, this is sad, you get an IRQ after every segment ...)

> You'll find that lvalue use of sg_dma_len() fails on some platforms that
> actually compute it from page/offset values in the scatterlist.
>=20
> Could you (eventually) update tmscsim not to use it?

We could just define our own format, make a copy and then use that one.

Regards,
--=20
Kurt Garloff  <garloff@suse.de>                            Cologne, DE=20
SUSE LINUX AG / Novell, Nuernberg, DE               Director SUSE Labs

--tZCmRiovzb4sxAVa
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFArwq0xmLh6hyYd04RApM4AJ9vbsIBSgAa2iGBr9aGCfNlpFd3LQCeMVWh
RBnnw6qWgVl7kCi/4TUmbqE=
=EMHi
-----END PGP SIGNATURE-----

--tZCmRiovzb4sxAVa--
