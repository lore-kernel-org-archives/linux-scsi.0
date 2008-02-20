From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: DMA API Re: Remove dma_coherent_mem interface
Date: Wed, 20 Feb 2008 10:14:09 -0700
Message-ID: <20080220171409.GB27736@parisc-linux.org>
References: <1193864605.25899.253.camel@wirenth>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:44229 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934239AbYBTROL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Feb 2008 12:14:11 -0500
Content-Disposition: inline
In-Reply-To: <1193864605.25899.253.camel@wirenth>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ian <spyro@f2s.com>
Cc: linux-arch@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, linux-scsi@vger.kernel.org, jejb@steeleye.com, kernel-discuss@handhelds.org

On Wed, Oct 31, 2007 at 09:03:24PM +0000, ian wrote:
> I'd like to ask that this not happen - there are several users of this
> code in the handhelds.org tree, which we hope will merge into mainline.
> this code is _essential_ to allow support of these devices.

So ... it's been 4 months.  Any new users merged?

-- 
Intel are signing my paycheques ... these opinions are still mine
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
