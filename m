From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 2.6.22-rc3-mm1
Date: Thu, 31 May 2007 16:13:38 +0100
Message-ID: <20070531151338.GA759@infradead.org>
References: <20070530235823.793f00d9.akpm@linux-foundation.org> <20070531140922.2e55aefb@gondolin.boeblingen.de.ibm.com> <20070531121557.GQ23968@parisc-linux.org> <20070531142048.05edf133@gondolin.boeblingen.de.ibm.com> <465EC101.7010105@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:55902 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641AbXEaPOE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 May 2007 11:14:04 -0400
Content-Disposition: inline
In-Reply-To: <465EC101.7010105@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Cornelia Huck <cornelia.huck@de.ibm.com>, Matthew Wilcox <matthew@wil.cx>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>, Dan Williams <dan.j.williams@intel.com>

On Thu, May 31, 2007 at 08:35:13AM -0400, Jeff Garzik wrote:
> Cornelia Huck wrote:
> >On Thu, 31 May 2007 06:15:57 -0600,
> >Matthew Wilcox <matthew@wil.cx> wrote:
> >
> >>On Thu, May 31, 2007 at 02:09:22PM +0200, Cornelia Huck wrote:
> >>>I split those functions out into a new file. Builds on s390 and i386.
> >>Why not just put #ifdef CONFIG_HAS_DMA / #endif around the pair of
> >>functions?  I don't see the need to add a new Kconfig symbol and a new
> >>file for this.
> >
> >I prefer a new file over #ifdefs in c files. (New dma-dependent stuff
> >would also have a place where it could go to.)
> >
> >But I'll do whatever ends up as consensus :)
> 
> 50 lines isn't much need for a new file.

The scsi core shouldn't know anything about dma mappings, so a separate
file is a good idea just to keep the separation clean.
