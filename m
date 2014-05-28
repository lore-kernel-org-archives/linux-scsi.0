From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 3/4] scsi: increase upper limit for max_sectors
Date: Wed, 28 May 2014 21:28:00 +0900
Message-ID: <CAC5umygh5YBrpt-L8utZVdmwN-8xUhp99JuOJzUhRD4Hn6f7yg@mail.gmail.com>
References: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
	<1401021816-10423-4-git-send-email-akinobu.mita@gmail.com>
	<20140528103931.GC13542@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-la0-f54.google.com ([209.85.215.54]:38325 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752124AbaE1M2C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 08:28:02 -0400
Received: by mail-la0-f54.google.com with SMTP id pv20so7198828lab.41
        for <linux-scsi@vger.kernel.org>; Wed, 28 May 2014 05:28:00 -0700 (PDT)
In-Reply-To: <20140528103931.GC13542@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

Hi Christoph,

Thanks for your review.

2014-05-28 19:39 GMT+09:00 Christoph Hellwig <hch@infradead.org>:
> Looks good, but I think this should be three patches, one for the ioctl
> in sg, one for the command selection in sd, and one to change the field
> with in the scsi core.

OK, I'll break this into three patches and rearrange the patchset for
next submission.
