From: Arjan van de Ven <arjanv@redhat.com>
Subject: Re: I2O enhancement for Adaptec management software
Date: Mon, 5 Apr 2004 12:10:08 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040405101007.GA27710@devserv.devel.redhat.com>
References: <40712A47.4090903@shadowconnect.com> <1081159378.4679.1.camel@laptop.fenrus.com> <20040405110524.A3987@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:14730 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S263174AbUDEKKk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Apr 2004 06:10:40 -0400
Content-Disposition: inline
In-Reply-To: <20040405110524.A3987@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>, linux-scsi@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline


On Mon, Apr 05, 2004 at 11:05:24AM +0100, Christoph Hellwig wrote:
> On Mon, Apr 05, 2004 at 12:02:59PM +0200, Arjan van de Ven wrote:
> > is there a convincing argument why this can't use the SG_IO mechanism
> > instead of a device private ioctl ?
> 
> Yes.  These are i2o commands, not scsi commands.

does that matter really ?
Does SG_IO specify "it's scsi" or "it's native format" :)

--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.1 (GNU/Linux)

iD8DBQFAcTB/xULwo51rQBIRAgvYAJ4jTmmWtRA1kJNgn08jCzNrCyngpwCfT4FX
dp/O5bIVhvycTxQEBdRSXnU=
=WBJr
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
