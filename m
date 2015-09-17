From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Fwd: [lkp] [dma] 6894258eda: mpt2sas0: reply_post_free pool:
 pci_pool_alloc failed
Date: Thu, 17 Sep 2015 23:11:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.11.1509172310420.3951@nanos>
References: <87lhc5g3a6.fsf@yhuang-dev.intel.com> <CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com> <20150917200609.GA14601@infradead.org> <CA+55aFz-a+U+dmo9yaYMm0p751Q6xkfuUUV9Zwta87dhY4iRvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from www.linutronix.de ([62.245.132.108]:54776 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751874AbbIQVMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 17:12:18 -0400
In-Reply-To: <CA+55aFz-a+U+dmo9yaYMm0p751Q6xkfuUUV9Zwta87dhY4iRvQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christoph Hellwig <hch@infradead.org>, Guenter Roeck <linux@roeck-us.net>, Max Filippov <jcmvbkbc@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, James Bottomley <jbottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Junichi Nomura <j-nomura@ce.jp.nec.com>

On Thu, 17 Sep 2015, Linus Torvalds wrote:

> On Thu, Sep 17, 2015 at 1:06 PM, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > This was caused by my commit, and I already acked a patch from Junichi
> > Nomura to fix which should land in your inbox ASAP.

I'll send a pull request tomorrow.

Thanks,

	tglx

