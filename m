From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Removing BROKEN scsi drivers
Date: Wed, 5 Oct 2005 12:39:25 +0100
Message-ID: <20051005113925.GA11202@infradead.org>
References: <200510051314.33411.ak@suse.de> <20051005113108.GA19437@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22450 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S965120AbVJELj1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Oct 2005 07:39:27 -0400
Content-Disposition: inline
In-Reply-To: <20051005113108.GA19437@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Andi Kleen <ak@suse.de>, linux-scsi@vger.kernel.org, richard@sleepie.demon.co.uk

On Wed, Oct 05, 2005 at 05:31:08AM -0600, Matthew Wilcox wrote:
> On Wed, Oct 05, 2005 at 01:14:32PM +0200, Andi Kleen wrote:
> > SCSI_AMIGA7XX - no maintainer, broken forever
> > MVME16x_SCSI - no maintainer, broken forever
> > BVME6000_SCSI - same
> 
> I don't think there's any point in deleting these.  I'm not even sure
> why they're marked BROKEN.  They share 99% of their code with drivers
> which are working.  And I thought Richard Hirst was maintaining them ...

They don't.  All these use the broken and obsolete 53c7xx driver, not
James new 53c700 core.  The driver should be easy to reimplement based
on the 53x700 for someone who has the hardware and cares about it.

