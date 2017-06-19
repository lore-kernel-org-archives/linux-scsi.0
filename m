From: Christoph Hellwig <hch@lst.de>
Subject: Re: [lkp-robot] [scsi]  ebc76736f2: fio.write_bw_MBps -4%
        regression
Date: Mon, 19 Jun 2017 11:39:13 +0200
Message-ID: <20170619093913.GA15040@lst.de>
References: <20170616082755.22832-1-hch@lst.de> <20170619060318.GC23108@yexl-desktop> <20170619070923.GA13129@lst.de> <20170619074943.GA20152@yexl-desktop> <20170619084153.GA14788@lst.de> <20170619085236.GB20152@yexl-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170619085236.GB20152@yexl-desktop>
Sender: linux-block-owner@vger.kernel.org
To: Ye Xiaolong <xiaolong.ye@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, lkp@01.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 19, 2017 at 04:52:36PM +0800, Ye Xiaolong wrote:
> >I've not seen a compile-time option for the MQ I/O scheduler (unlike
> >the legacy one), so the way to change it would be to echo the name to
> >/sys/block/<device>/queue/scheduler 
> 
> echo mq-deadline > /sys/block/<device>/queue/scheduler ?
> 
> I'll try and post the results once I get it.

Thanks!
