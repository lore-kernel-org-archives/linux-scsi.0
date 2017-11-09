From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH v12 0/7] block, scsi: Improve suspend and resume
Date: Thu, 9 Nov 2017 14:00:28 -0700
Message-ID: <253ed84c-8395-846a-43cd-0d4c5df8c416@kernel.dk>
References: <20171109184959.4617-1-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f193.google.com ([209.85.223.193]:54714 "EHLO
        mail-io0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751017AbdKIVAa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Nov 2017 16:00:30 -0500
Received: by mail-io0-f193.google.com with SMTP id e89so11323966ioi.11
        for <linux-scsi@vger.kernel.org>; Thu, 09 Nov 2017 13:00:30 -0800 (PST)
In-Reply-To: <20171109184959.4617-1-bart.vanassche@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@wdc.com>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, "Martin K . Petersen" <martin.petersen@oracle.com>, Oleksandr Natalenko <oleksandr@natalenko.name>, Ming Lei <ming.lei@redhat.com>, Martin Steigerwald <martin@lichtvoll.de>

On 11/09/2017 11:49 AM, Bart Van Assche wrote:
> Hello Jens,
> 
> It is known that during the resume following a hibernate, especially when
> using an md RAID1 array created on top of SCSI devices, sometimes the system
> hangs instead of resuming up properly. This patch series fixes that
> problem. These patches have been tested on top of the block layer for-next
> branch. Please consider these changes for kernel v4.15.

Applied, thanks Bart.

-- 
Jens Axboe
