From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 2/3] aic79xx: Update to adaptec version 2.0.14
Date: Mon, 16 Jan 2006 05:39:10 -0700
Message-ID: <20060116123910.GA19769@parisc-linux.org>
References: <43CB6F8F.7040801@suse.de> <20060116120517.GB12554@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:40403 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1750723AbWAPMjK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jan 2006 07:39:10 -0500
Content-Disposition: inline
In-Reply-To: <20060116120517.GB12554@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 16, 2006 at 12:05:17PM +0000, Christoph Hellwig wrote:
> > -			*maddr = ioremap_nocache(base_page, base_offset + 256);
> > +			*maddr = ioremap_nocache(base_page, base_offset + 512);
> 
> so how could this work before?

In the absence of chip documentation, maybe the registers are mapped
several times over, once at +0, once at +256, once at +512, each time with
slightly different semantics?  We definitely have chips with register
files in IO space, Mem space and Config space, so choosing to map the
registers several times in the same address space probably just doesn't
seem terribly crazy to hardware people ;-)

Are Adaptec planning on releasing chip documentation?
