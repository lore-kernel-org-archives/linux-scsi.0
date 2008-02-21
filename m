From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Fri, 22 Feb 2008 01:32:02 +0900
Message-ID: <20080221163202.GA13873@linux-sh.org>
References: <1193864605.25899.253.camel@wirenth> <20080220171409.GB27736@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pip23.gyao.ne.jp ([125.63.38.249]:45982 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757661AbYBUQc2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Feb 2008 11:32:28 -0500
Content-Disposition: inline
In-Reply-To: <20080220171409.GB27736@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: ian <spyro@f2s.com>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Wed, Feb 20, 2008 at 10:14:09AM -0700, Matthew Wilcox wrote:
> On Wed, Oct 31, 2007 at 09:03:24PM +0000, ian wrote:
> > I'd like to ask that this not happen - there are several users of this
> > code in the handhelds.org tree, which we hope will merge into mainline.
> > this code is _essential_ to allow support of these devices.
> 
> So ... it's been 4 months.  Any new users merged?
> 
The sm501 ohci is the case I had mentioned previously, that's in-tree
now.
