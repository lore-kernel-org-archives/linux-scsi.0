From: Aristeu Sergio Rozanski Filho <aris@cathedrallabs.org>
Subject: [patch][0/15] qlogicfas/qlogic_cs
Date: Tue, 9 Mar 2004 10:32:17 -0300
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040309133217.GB651@cathedrallabs.org>
References: <20031020232200.GA473@cathedrallabs.org> <20040219150747.A23822@infradead.org> <20040219172619.GA667@cathedrallabs.org> <1077399404.2285.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; x-action=pgp-signed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from panda.sul.com.br ([200.219.150.4]:56585 "EHLO panda.sul.com.br")
	by vger.kernel.org with ESMTP id S261914AbUCINgt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2004 08:36:49 -0500
Content-Disposition: inline
In-Reply-To: <1077399404.2285.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

James, Christoph, list,
> I'll put them in, but first I think the qlogicfas attachment type needs
> to be all new style.
please drop all patches that I've sent before and consider applying these
I'm sending instead. I wonder if will be worth to split qlogicfas in two
different modules: one for hardware functions and other for qlogicfas driver
so qlogic_cs can share the same code instead copying it. comments?

- --
aris
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFATcdhRRJOudsVYbMRAhP2AJ0fnMoNDdvUtHIghCE33Q2+pAPMpACglPcm
b5MSVpF7yNcm25ERldb8Dqg=
=h6q0
-----END PGP SIGNATURE-----
