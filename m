From: Jens Axboe <axboe@suse.de>
Subject: Re: Warning - running *really* short on DMA buffers while doing file transfers
Date: Thu, 26 Sep 2002 08:14:19 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020926061419.GA12862@suse.de>
References: <20020925232736.A19209@shookay.newview.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020925232736.A19209@shookay.newview.com>
List-Id: linux-scsi@vger.kernel.org
To: Mathieu Chouquet-Stringer <mathieu@newview.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Sep 25 2002, Mathieu Chouquet-Stringer wrote:
> 	  Hello!
> 
> I've upgraded a while to 2.4.19 and my box has been happy for the last 52
> days (it's a dual PIII). Tonight while going through my logs, I've found
> these:
> 
> Sep 25 22:18:41 bigip kernel: Warning - running *really* short on DMA buffers
> Sep 25 22:18:47 bigip last message repeated 55 times
> Sep 25 22:19:41 bigip last message repeated 71 times

This is fixed in 2.4.20-pre

> Oh BTW, just one thing, I wanted to give the throughput of the ide drived
> but it failed:
> Sep 25 23:18:32 bigip kernel: hdb: dma_intr: status=0x51 { DriveReady SeekComplete Error }
> Sep 25 23:18:32 bigip kernel: hdb: dma_intr: error=0x40 { UncorrectableError }, LBAsect=102882, sector=102784

Yep, looks like the end of the road for that drive.

-- 
Jens Axboe

