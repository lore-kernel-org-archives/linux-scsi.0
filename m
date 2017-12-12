From: Jia-Ju Bai <baijiaju1990@163.com>
Subject: Re: [PATCH] NCR5380: Fix a possible sleep-in-atomic bug in
 NCR5380_poll_politely2
Date: Tue, 12 Dec 2017 11:49:32 +0800
Message-ID: <20fa69d8-7bfe-0ce4-b547-cc7372726bde@163.com>
References: <1513047037-18102-1-git-send-email-baijiaju1990@163.com>
 <alpine.LNX.2.21.1712121429331.3@nippy.intranet>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:60642 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751123AbdLLDtt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Dec 2017 22:49:49 -0500
In-Reply-To: <alpine.LNX.2.21.1712121429331.3@nippy.intranet>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>
Cc: schmitzmic@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>

Thanks for your reply :)

On 2017/12/12 11:38, Finn Thain wrote:
> On Tue, 12 Dec 2017, Jia-Ju Bai wrote:
>
>> From: Jia-Ju Bai <baijiaju1990@gmail.com>
>>
>> The kernel module may sleep under a spinlock.
> The spinlock is always taken in irq mode, and the
> schedule_timeout_uninterruptible() is conditional on !irqs_disabled().
>
I think I ignore this check, which causes a false bug report, sorry.


Thanks,
Jia-Ju Bai
