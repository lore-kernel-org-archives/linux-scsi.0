From: "Torsten Kaiser" <just.for.lkml@googlemail.com>
Subject: Re: 2.6.23-rc4-mm1
Date: Mon, 10 Sep 2007 22:43:07 +0200
Message-ID: <64bb37e0709101343t2a621239pfc3545263e0b7674@mail.gmail.com>
References: <20070910111926.9c942358.akpm@linux-foundation.org>
	 <64bb37e0709101159v47f586aby7f078ef1db5cbc39@mail.gmail.com>
	 <20070910122038.1f1bb006.akpm@linux-foundation.org>
	 <20070910045503O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.183]:38933 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759382AbXIJUnJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Sep 2007 16:43:09 -0400
Received: by py-out-1112.google.com with SMTP id u77so2708338pyb
        for <linux-scsi@vger.kernel.org>; Mon, 10 Sep 2007 13:43:09 -0700 (PDT)
In-Reply-To: <20070910045503O.tomof@acm.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: akpm@linux-foundation.org, apw@shadowen.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie, jens.axboe@oracle.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On 9/10/07, FUJITA Tomonori <tomof@acm.org> wrote:
> On Mon, 10 Sep 2007 12:20:38 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
>
> > On Mon, 10 Sep 2007 20:59:49 +0200 "Torsten Kaiser" <just.for.lkml@googlemail.com> wrote:
> > > The system boots, reads the partition tables, starts the RAID and then
> > > kicks one drive out because of errors.
> >
> > Andy is using qla1280.  You're using sata.  So it's probably a different
> > bug, with the same symptoms.
>
> This might be a sg chaining bug too (probabaly sg chaining libata
> patch).
>
> Can you try the following patch that I've just sent:
>
> http://lkml.org/lkml/2007/9/10/251
>
> The patch also disables chaining sg list for libata.
>
With this patch 2.6.23-rc4-mm1 works for me.
Mainline 2.6.23-rc5-git1 works also without needing any patches.

Torsten
