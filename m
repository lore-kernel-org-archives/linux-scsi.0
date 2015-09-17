From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Fwd: [lkp] [dma] 6894258eda: mpt2sas0: reply_post_free pool:
 pci_pool_alloc failed
Date: Thu, 17 Sep 2015 13:06:09 -0700
Message-ID: <20150917200609.GA14601@infradead.org>
References: <87lhc5g3a6.fsf@yhuang-dev.intel.com>
 <CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:49598 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbIQUGO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 16:06:14 -0400
Content-Disposition: inline
In-Reply-To: <CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Max Filippov <jcmvbkbc@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, James Bottomley <jbottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, j-nomura@ce.jp.nec.com, Thomas Gleixner <tglx@linutronix.de>

On Thu, Sep 17, 2015 at 11:38:01AM -0700, Linus Torvalds wrote:
> This was missing the rest of the sign-off chain, and the scsi/mpt
> people who might have more ideas about why that change causes problems
> for mpt2sas.

This was caused by my commit, and I already acked a patch from Junichi
Nomura to fix which should land in your inbox ASAP.
