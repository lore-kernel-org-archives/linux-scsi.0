From: oleksandr@natalenko.name
Subject: Re: [PATCH 0/9] block/scsi: safe SCSI quiescing
Date: Fri, 01 Sep 2017 08:24:46 +0200
Message-ID: <eeb514d8aab51d4713f18636adb6be03@natalenko.name>
References: <20170831172728.15817-1-ming.lei@redhat.com>
 <1576539.niWZoWEnd8@natalenko.name> <20170831173833.GC5928@ming.t460p>
 <14328863.IIXMb7O2AM@natalenko.name> <20170901034532.GD16525@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vulcan.natalenko.name ([104.207.131.136]:31080 "EHLO
        vulcan.natalenko.name" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751422AbdIAGYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Sep 2017 02:24:50 -0400
In-Reply-To: <20170901034532.GD16525@ming.t460p>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>

Hi.

01.09.2017 05:45, Ming Lei wrote:
> Could you try the following patch against this patchset to see
> if there is still the warning?

With this patch I wasn't able to trigger per-CPU-related warning.

Also, for 8th patch you've written:

> I have sent one delta patch in list, which will only call 
> blk_queue_enter_live() iff SCSI device is in QUIESCE.

This refers to the patch I've just tested, right?
