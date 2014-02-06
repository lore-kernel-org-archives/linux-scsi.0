From: Muthu Kumar <muthu.lkml@gmail.com>
Subject: Re: [PATCH 02/15] blk-mq: support at_head inserations for blk_execute_rq
Date: Thu, 6 Feb 2014 09:05:10 -0800
Message-ID: <CAFR8uedQ2kHP6caUQewSixtRbOw7vWjyaJtK66ENbOVUJLXAag@mail.gmail.com>
References: <20140205124118.332902571@bombadil.infradead.org>
	<20140205124152.477413324@bombadil.infradead.org>
	<CAFR8uedLQyX7aFsuOs4UFYE=sYUOG+jpPMOQzqOW4f_RQGsf2g@mail.gmail.com>
	<20140206161710.GB16916@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f171.google.com ([209.85.192.171]:36127 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754359AbaBFRFL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Feb 2014 12:05:11 -0500
Received: by mail-pd0-f171.google.com with SMTP id g10so1941874pdj.2
        for <linux-scsi@vger.kernel.org>; Thu, 06 Feb 2014 09:05:11 -0800 (PST)
In-Reply-To: <20140206161710.GB16916@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, James Bottomley <JBottomley@parallels.com>, Nicholas Bellinger <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, Bart Van Assche <bvanassche@acm.org>

On Thu, Feb 6, 2014 at 8:17 AM, Christoph Hellwig <hch@infradead.org> wrote:
> On Wed, Feb 05, 2014 at 06:27:38PM -0800, Muthu Kumar wrote:
>> Currently its not used by any drivers. Are we sure we don't need it
>> public? If sure, please remove the EXPORT_SYMBOL() for it.
>
> Drivers shouldn't use it, it's a low-level interface.  As mentioned in
> the intro this is not quite a coherent series yet, but I'll post the
> blk-mq patches in a slightly nicer form agains Jens' tree soon.
>

Alright then.. I will wait for that patch. BTW, is the scsi-mq work
done on your git tree only or anyone else has their own git tree
(Bart? NAB?)?
