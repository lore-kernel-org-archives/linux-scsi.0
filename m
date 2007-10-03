From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 2/16] gdth: split out eisa probing
Date: Wed, 3 Oct 2007 19:32:24 +0200
Message-ID: <200710031932.35187.eike-kernel@sf-tec.de>
References: <46FFFC8C.6080804@panasas.com> <200710021920.40354.eike-kernel@sf-tec.de> <20071003172737.GA6446@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1490861.b7naF0VsR1";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:47632 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbXJCRcZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 13:32:25 -0400
In-Reply-To: <20071003172737.GA6446@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart1490861.b7naF0VsR1
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Christoph Hellwig wrote:
> On Tue, Oct 02, 2007 at 07:20:38PM +0200, Rolf Eike Beer wrote:
> > Same thing as in ISA patch: this is not PCI and we should not hide what
> > we're doing so dma_alloc_consistent(NULL, ...) is better IMHO.
>
> passing NULL is the documented way to deal with ISA/EISA devices with
> the old pci dma api.  Any change to these APIs should be a different
> patch, and there's about 100 more important things in gdth right now.

It's not about passing NULL there. We need to do that. But we should call i=
t=20
with NULL as argument and not with ha->pdev to make this obvious.

Eike

--nextPart1490861.b7naF0VsR1
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHA9IzXKSJPmm5/E4RAjYKAJ0bdyo5xA3ApQaardHCA757InN/MwCdGpRK
4F9AxMh5fDpT6QiRNb4ZWYI=
=k2Sx
-----END PGP SIGNATURE-----

--nextPart1490861.b7naF0VsR1--
