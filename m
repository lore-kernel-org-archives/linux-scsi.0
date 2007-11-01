From: Paul Mundt <lethal@linux-sh.org>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Thu, 1 Nov 2007 19:07:17 +0900
Message-ID: <20071101100717.GA26906@linux-sh.org>
References: <1193864605.25899.253.camel@wirenth> <20071031213447.GF15111@parisc-linux.org> <1193910526.25899.278.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pip15.gyao.ne.jp ([61.122.117.253]:19291 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756306AbXKAKH5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2007 06:07:57 -0400
Content-Disposition: inline
In-Reply-To: <1193910526.25899.278.camel@wirenth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ian <spyro@f2s.com>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Thu, Nov 01, 2007 at 09:48:46AM +0000, ian wrote:
> On Wed, 2007-10-31 at 15:34 -0600, Matthew Wilcox wrote:
> >   It may not be significant, so it would be an easy decision to keep
> >   the interface.  But if the decision is going to be to keep the
> >   interface despite the lack of users and no matter what the
> >   performance win, then I don't need to finish this work.
> 
> I dont mind what the interface is as long as we can support devices that
> can only DMA from their own local RAM as described above...
> 
Indeed. The SH case for OHCI on MFDs is the same. So that's at least 2
users.
