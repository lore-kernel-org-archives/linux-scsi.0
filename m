From: Jens Axboe <axboe@suse.de>
Subject: Re: Executing a scsi command
Date: Fri, 8 Nov 2002 17:24:01 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021108162401.GB32005@suse.de>
References: <3DCA6E46.91894890@patni.com> <3DCBE4C7.DB1AEE9F@patni.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3DCBE4C7.DB1AEE9F@patni.com>
List-Id: linux-scsi@vger.kernel.org
To: MShetty <mranalini.shetty@patni.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Nov 08 2002, MShetty wrote:
> Hi,
> 
> Does request_queue's queuedata contain the Scsi_Device pointer ?? Saw it
> done in scsi_merge.c
> 
>       Scsi_Device *SDpnt;
>       struct Scsi_Host *SHpnt;
> 
>       SDpnt = (Scsi_Device *) q->queuedata;
>       SHpnt = SDpnt->host;
> 
> Would help if I could get some comment on the above.

Well what's there to comment about? Yes ->queuedata holds pointer to
SCSI device, the block layer queues are per-device.

-- 
Jens Axboe

