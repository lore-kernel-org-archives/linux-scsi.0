From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v10 00/10] block, scsi, md: Improve suspend and resume
Date: Tue, 17 Oct 2017 17:28:14 -0600
Message-ID: <9c33db06-39e7-fd61-f146-4ae6df4302b5@kernel.dk>
References: <20171017232630.4264-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f43.google.com ([74.125.83.43]:46180 "EHLO
        mail-pg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1761506AbdJQX2T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2017 19:28:19 -0400
Received: by mail-pg0-f43.google.com with SMTP id k7so2688594pga.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2017 16:28:18 -0700 (PDT)
In-Reply-To: <20171017232630.4264-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>

On 10/17/2017 05:26 PM, Bart Van Assche wrote:
> Hello Jens,
> 
> It is known that during the resume following a hibernate, especially when
> using an md RAID1 array created on top of SCSI devices, sometimes the system
> hangs instead of coming up properly. This patch series fixes that
> problem. These patches have been tested on top of the block layer for-next
> branch. Please consider these changes for kernel v4.15.

The folks that had trouble with this issue, have they tested the
patchset? I'd like to get a solution queued up for this sooner rather
than later, but I'd greatly prefer if we had some folks that have
tested and verified it.

-- 
Jens Axboe
