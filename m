From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH-v1 00/22] lpfc updates for 11.2.0.12
Date: Thu, 20 Apr 2017 12:30:48 -0600
Message-ID: <20170420183047.GD22378@kernel.dk>
References: <20170420044641.10657-1-jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:36292 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S945371AbdDTSau (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Apr 2017 14:30:50 -0400
Received: by mail-io0-f170.google.com with SMTP id o22so89158003iod.3
        for <linux-scsi@vger.kernel.org>; Thu, 20 Apr 2017 11:30:50 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20170420044641.10657-1-jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, sagi@grimberg.me, martin.petersen@oracle.com

On Wed, Apr 19 2017, jsmart2021@gmail.com wrote:
> From: James Smart <jsmart2021@gmail.com>
> 
> This patch set provides a number of bug fixes, code cleanups, and error
> handling, mostly in the nvme area of lpfc.
> 
> There is one new feature in the series to add Fabric Assigned WWN support.
> 
> The patches were cut against the linux-block tree, for-4.12/block branch,
> and are intended to be pulled in through that tree rather than the scsi trees.
> 
> The patches are dependent on the FC nvme/nvmet patches from the following 2
> series:
> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009250.html
> http://lists.infradead.org/pipermail/linux-nvme/2017-April/009256.html

James, if you can address the (minor) review comments from Johannes and
repost with the reviewed/tested-by collected, we can get this applied. I
almost applied it as-is, but we may as well just get the last little
bits fixed up.

Thanks!

-- 
Jens Axboe
