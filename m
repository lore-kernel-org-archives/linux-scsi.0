From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: Re: [patch] qlogic: don't use qinfo as name
Date: Mon, 1 Mar 2004 22:27:36 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040302012735.GA656@cathedrallabs.org>
References: <20031020232200.GA473@cathedrallabs.org> <20040219150747.A23822@infradead.org> <20040219172619.GA667@cathedrallabs.org> <1077399404.2285.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:65038 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261544AbUCBBaa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2004 20:30:30 -0500
Content-Disposition: inline
In-Reply-To: <1077399404.2285.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi James,
> I'll put them in, but first I think the qlogicfas attachment type needs
> to be all new style.
> 
> This:
> 
> > +#ifdef PCMCIA
> > +	hreg = scsi_host_alloc(host, 0);
> > +#else
> >  	hreg = scsi_register(host, 0);	/* no host data */
> > +#endif
> 
> Mixing of new and old styles is bound to cause difficulty.
I'm working on that, sorry for the delay, I took last week off.

- --
aris
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAQ+MHRRJOudsVYbMRAr9nAKCYVr/FAhiaYYscKvAkKu9g2IeFJQCgmPyx
dTWt0tZsQyFag3xBlhMSqDE=
=xsMc
-----END PGP SIGNATURE-----
