From: Ye Xiaolong <xiaolong.ye@intel.com>
Subject: Re: [lkp-robot] [scsi]  ebc76736f2: fio.write_bw_MBps -4% regression
Date: Mon, 19 Jun 2017 16:52:36 +0800
Message-ID: <20170619085236.GB20152@yexl-desktop>
References: <20170616082755.22832-1-hch@lst.de>
 <20170619060318.GC23108@yexl-desktop>
 <20170619070923.GA13129@lst.de>
 <20170619074943.GA20152@yexl-desktop>
 <20170619084153.GA14788@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:4976 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753807AbdFSIwr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Jun 2017 04:52:47 -0400
Content-Disposition: inline
In-Reply-To: <20170619084153.GA14788@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, lkp@01.org, Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org

On 06/19, Christoph Hellwig wrote:
>On Mon, Jun 19, 2017 at 03:49:43PM +0800, Ye Xiaolong wrote:
>> On 06/19, Christoph Hellwig wrote:
>> >On Mon, Jun 19, 2017 at 02:03:18PM +0800, kernel test robot wrote:
>> >> 
>> >> Greeting,
>> >> 
>> >> FYI, we noticed a -4% regression of fio.write_bw_MBps due to commit:
>> >
>> >What does cat /sys/block/<device>/queue/scheduler say for your test?
>> >Can you try with mq-deadline or bfq and see what the results are?
>> 
>> Could you tell me how to do it? via changing kernel config?
>
>BFQ doesn't seem to be enabled in the config, so it would have to be
>enabled.
>
>I've not seen a compile-time option for the MQ I/O scheduler (unlike
>the legacy one), so the way to change it would be to echo the name to
>/sys/block/<device>/queue/scheduler 

echo mq-deadline > /sys/block/<device>/queue/scheduler ?

I'll try and post the results once I get it.

Thanks,
Xiaolong
