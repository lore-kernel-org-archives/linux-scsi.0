From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: qla2xxx and feral ISP updates in their respective BK trees
Date: Fri, 20 Jun 2003 14:34:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030620183417.GB9164@gtf.org>
References: <1055971780.2075.484.camel@mulgrave> <20030620101224.B305@wonky.in0.lcl> <1056129548.2102.19.camel@mulgrave> <20030620102448.O305@wonky.in0.lcl> <1056133068.1804.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host-64-213-145-173.atlantasolutions.com ([64.213.145.173]:52420
	"EHLO havoc.gtf.org") by vger.kernel.org with ESMTP id S264072AbTFTSUR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2003 14:20:17 -0400
Content-Disposition: inline
In-Reply-To: <1056133068.1804.22.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: mjacob@feral.com, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Vasquez <praka@san.rr.com>, Andrew Morton <akpm@digeo.com>

On Fri, Jun 20, 2003 at 01:17:46PM -0500, James Bottomley wrote:
> On Fri, 2003-06-20 at 12:25, Matthew Jacob wrote:
> > Oh- is parisc like PPC and doesn't really support io space? That is,
> > prefers memory mapped registers?
> 
> Well, it does, for PCI (since it's required to by the spec).  However,
> the cost of generating an I/O cycle is very high (you essentially go via
> some memory mapped registers in the bus controller).  Parisc certainly
> prefers memory mapped registers.

Is there hardware that supports both PIO and MMIO... and actually
prefers PIO?

I know of no such situation -- outside of hardware bugs and driver bugs,
which force the use of PIO, where both are available.

Pretty much everybody prefers memory mapped registers :)

	Jeff



