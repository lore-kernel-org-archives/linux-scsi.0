From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 18:07:41 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040615160741.GA27597@devserv.devel.redhat.com>
References: <40CF0F9F.4050902@adaptec.com> <1087313241.2710.40.camel@laptop.fenrus.com> <40CF1852.6030306@adaptec.com> <20040615154313.GA25397@devserv.devel.redhat.com> <40CF1A5D.30908@adaptec.com> <20040615155716.GA14017@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:41654 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265736AbUFOQIG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 12:08:06 -0400
Content-Disposition: inline
In-Reply-To: <20040615155716.GA14017@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 15, 2004 at 04:57:16PM +0100, Christoph Hellwig wrote:
> On Tue, Jun 15, 2004 at 11:48:45AM -0400, Luben Tuikov wrote:
> > This really isn't anything new or paramount.  It's just a simple
> > extension, marked OPTIONAL, that only *capable* drivers should use.
> > (i.e. the aic7xxx drivers, maybe some FC and USB).
> > 
> > So it's not really that big of a deal, but does wonders to
> > SCSI Core in terms of recovery time and *uninterruptible*
> > IO.
> 
> Well, the question is always what is so special about your driver that
> it doesn't benefit from beeing in a common library.  I've pulled more crap
> out of individual drivers than I'd ever want to imagine, and because of
> that I'm pretty much allergic against giving driver writers more control
> then nessecary.

I agree with Christoph; if it makes sense then it makes sense in the common
layer, not so much in the hardware driver.

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAzx7MxULwo51rQBIRAra3AKCNRC3kBzZF/W8nKvC4PV/HXOUN9gCeO+QH
nsJW6VQRH6R/fXzDO/f7/mo=
=2n+W
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
