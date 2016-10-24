From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: Device or HBA level QD throttling creates randomness in sequetial workload
Date: Mon, 24 Oct 2016 18:35:01 +0530
Message-ID: <1f7cec69e6e12b6baa8e7f180a8e41b3@mail.gmail.com>
References: <97184c74229af78b0d97e6b8016af972@mail.gmail.com> <20161021213121.GA10030@vader.DHCP.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yb0-f178.google.com ([209.85.213.178]:34314 "EHLO
        mail-yb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936015AbcJXNO6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Oct 2016 09:14:58 -0400
Received: by mail-yb0-f178.google.com with SMTP id f97so75107953ybi.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2016 06:14:57 -0700 (PDT)
In-Reply-To: <20161021213121.GA10030@vader.DHCP.thefacebook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, Christoph Hellwig <hch@infradead.org>, paolo.valente@linaro.org

>
> On Fri, Oct 21, 2016 at 05:43:35PM +0530, Kashyap Desai wrote:
> > Hi -
> >
> > I found below conversation and it is on the same line as I wanted some
> > input from mailing list.
> >
> > http://marc.info/?l=linux-kernel&m=147569860526197&w=2
> >
> > I can do testing on any WIP item as Omar mentioned in above
discussion.
> > https://github.com/osandov/linux/tree/blk-mq-iosched

I tried build kernel using this repo, but looks like it is not allowed to
reboot due to some changes in <block> layer.

>
> Are you using blk-mq for this disk? If not, then the work there won't
affect you.

YES. I am using blk-mq for my test. I also confirm if use_blk_mq is
disable, Sequential work load issue is not seen and <cfq> scheduling works
well.

>
> > Is there any workaround/alternative in latest upstream kernel, if user
> > wants to see limited penalty  for Sequential Work load on HDD ?
> >
> > ` Kashyap
> >
