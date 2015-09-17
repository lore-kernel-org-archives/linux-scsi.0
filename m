From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Fwd: [lkp] [dma] 6894258eda: mpt2sas0: reply_post_free pool:
 pci_pool_alloc failed
Date: Thu, 17 Sep 2015 13:08:45 -0700
Message-ID: <CA+55aFz-a+U+dmo9yaYMm0p751Q6xkfuUUV9Zwta87dhY4iRvQ@mail.gmail.com>
References: <87lhc5g3a6.fsf@yhuang-dev.intel.com>
	<CA+55aFwbbRxBMA7p+NC-g6VuKkSJQjgrJ-y0nngRseARFXcxFA@mail.gmail.com>
	<20150917200609.GA14601@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:33356 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792AbbIQUIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2015 16:08:46 -0400
Received: by iofh134 with SMTP id h134so34822143iof.0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2015 13:08:45 -0700 (PDT)
In-Reply-To: <20150917200609.GA14601@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Max Filippov <jcmvbkbc@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>, James Bottomley <jbottomley@parallels.com>, Huang Ying <ying.huang@intel.com>, Linux SCSI List <linux-scsi@vger.kernel.org>, Junichi Nomura <j-nomura@ce.jp.nec.com>, Thomas Gleixner <tglx@linutronix.de>

On Thu, Sep 17, 2015 at 1:06 PM, Christoph Hellwig <hch@infradead.org> wrote:
>
> This was caused by my commit, and I already acked a patch from Junichi
> Nomura to fix which should land in your inbox ASAP.

Thanks,

                 Linus
