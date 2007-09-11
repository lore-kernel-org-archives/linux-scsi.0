From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: 2.6.23-rc4-mm1
Date: Tue, 11 Sep 2007 10:32:04 +0200
Message-ID: <20070911083204.GE4187@kernel.dk>
References: <20070910111926.9c942358.akpm@linux-foundation.org> <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com> <20070910122038.1f1bb006.akpm@linux-foundation.org> <20070910045503O.tomof@acm.org> <64bb37e0709101343t2a621239pfc3545263e0b7674@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([87.55.233.238]:23385 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762951AbXIKIXe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Sep 2007 04:23:34 -0400
Content-Disposition: inline
In-Reply-To: <64bb37e0709101343t2a621239pfc3545263e0b7674@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Torsten Kaiser <just.for.lkml@googlemail.com>
Cc: FUJITA Tomonori <tomof@acm.org>, akpm@linux-foundation.org, apw@shadowen.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, Sep 10 2007, Torsten Kaiser wrote:
> On 9/10/07, FUJITA Tomonori <tomof@acm.org> wrote:
> > On Mon, 10 Sep 2007 12:20:38 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > > On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > > > The system boots, reads the partition tables, starts the RAID and then
> > > > kicks one drive out because of errors.
> > >
> > > Andy is using qla1280.  You're using sata.  So it's probably a different
> > > bug, with the same symptoms.
> >
> > This might be a sg chaining bug too (probabaly sg chaining libata
> > patch).
> >
> > Can you try the following patch that I've just sent:
> >
> > http://lkml.org/lkml/2007/9/10/251
> >
> > The patch also disables chaining sg list for libata.
> >
> With this patch 2.6.23-rc4-mm1 works for me.
> Mainline 2.6.23-rc5-git1 works also without needing any patches.

OK, thanks for testing that. I'll merge Tomo's patch so that we can
selectively enable drivers when we KNOW they work, instead of trying to
do this (massive) operation whole sale.

-- 
Jens Axboe

