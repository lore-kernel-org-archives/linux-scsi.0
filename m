From: Jens Axboe <axboe@kernel.dk>
Subject: Re: RFC: drop the T10 OSD code and its users
Date: Wed, 19 Apr 2017 09:11:45 -0600
Message-ID: <20170419151144.GA22579@kernel.dk>
References: <20170412160109.10598-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f52.google.com ([209.85.214.52]:36497 "EHLO
        mail-it0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936246AbdDSPLx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Apr 2017 11:11:53 -0400
Received: by mail-it0-f52.google.com with SMTP id b15so34884616iti.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Apr 2017 08:11:48 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170412160109.10598-1-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: ooo@electrozaur.com, martin.petersen@oracle.com, trond.myklebust@primarydata.com, osd-dev@open-osd.org, linux-nfs@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Apr 12 2017, Christoph Hellwig wrote:
> The only real user of the T10 OSD protocol, the pNFS object layout
> driver never went to the point of having shipping products, and the
> other two users (osdblk and exofs) were simple example of it's usage.
> 
> The code has been mostly unmaintained for years and is getting in the
> way of block / SCSI changes, so I think it's finally time to drop it.
> 
> These patches are against Jens' block for-next tree as that already

I've added 1/4 for now, as that one should obviously go. If we have
consensus to kill the rest, I'm all for it.

-- 
Jens Axboe
