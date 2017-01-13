From: Jens Axboe <axboe@kernel.dk>
Subject: Re: fix data transfer size caculation for special payload requests
Date: Fri, 13 Jan 2017 15:17:20 -0700
Message-ID: <20170113221720.GA16425@kernel.dk>
References: <1484306953-3194-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:32822 "EHLO
        mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751385AbdAMWRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2017 17:17:24 -0500
Received: by mail-io0-f173.google.com with SMTP id v96so54241930ioi.0
        for <linux-scsi@vger.kernel.org>; Fri, 13 Jan 2017 14:17:24 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <1484306953-3194-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Dexuan Cui <decui@microsoft.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org

On Fri, Jan 13 2017, Christoph Hellwig wrote:
> Hi all,
> 
> the first two fixes fix a regression in 4.10-rc1 where the data transfer
> size for discard commands wasn't set properly, leading to hangs with
> Hyper-V VMs.  The use the new data transfer size helper added in patch 1
> more widely.

Added for this series, thanks.

-- 
Jens Axboe

