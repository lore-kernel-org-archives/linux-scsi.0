From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH] Fix scsi/scsi_transport.h compile error
Date: Tue, 1 Aug 2006 08:10:04 +0200
Message-ID: <200608010810.15315.eike-kernel@sf-tec.de>
References: <200607310943.25384.eike-kernel@sf-tec.de> <44CE07AA.9030202@s5r6.in-berlin.de> <20060731143839.GC6087@athena.road.mcmartin.ca>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1770470.RcqhWilLLD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:44430 "EHLO mail.sf-mail.de")
	by vger.kernel.org with ESMTP id S1161130AbWHAGHp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2006 02:07:45 -0400
In-Reply-To: <20060731143839.GC6087@athena.road.mcmartin.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kyle McMartin <kyle@parisc-linux.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

--nextPart1770470.RcqhWilLLD
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Am Montag, 31. Juli 2006 16:38 schrieb Kyle McMartin:
> On Mon, Jul 31, 2006 at 03:37:46PM +0200, Stefan Richter wrote:
> > > This should be solved with a "struct scsi_device;" decl, instead of
> > > Yet More Header Dependancies...
> >
> > That function accesses members of the struct, i.e. the compiler needs to
> > know offsets into struct scsi_device at this point. Therefore it needs
> > the definition, not a declaration.
>
> Odd, ISTR that it only needed to be defined at the point the inline was
> used. Oh well, my bad.

That would be expected behaviour on a define.

Eike

--nextPart1770470.RcqhWilLLD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBEzvBHXKSJPmm5/E4RAvsYAJ9uyuF8qsB+4cJ8U1fYwoQmBYkG/QCfa2Cx
n+Z9amt6owc1QaA3505Togw=
=8CSr
-----END PGP SIGNATURE-----

--nextPart1770470.RcqhWilLLD--
