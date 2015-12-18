From: John Garry <john.garry@huawei.com>
Subject: Re: scsi-mq performance check
Date: Fri, 18 Dec 2015 16:50:46 +0000
Message-ID: <56743966.5010309@huawei.com>
References: <56741F04.3070506@huawei.com> <56742168.6030200@suse.de>
 <56742403.7000108@sandisk.com> <567427E8.8010608@huawei.com>
 <56742EC2.2020606@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:15829 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932264AbbLRQ4S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2015 11:56:18 -0500
In-Reply-To: <56742EC2.2020606@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, hch@infradead.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>


>> We have to lock due to how we reserve a slot in the delivery queue.
>> We are looking to optimise this, but it's not straightforward.
>>
>> Perf is a good strategy, but, to be honest, I have not spent a lot
>> of time looking at this so I'm looking for low hanging fruit initially.
>>
>> FYI, our hardware does have the same number of delivery and
>> completion queues (32), and 16 cores. One thing to note is that a
>> command which was sent on queue x is not quaranteed to complete on
>> queue y.
>>
> ... then don't bother looking at scsi-mq. That is the very thing it
> relies on ...
>
> Time to change the firmware?
>
> Cheers,
>
> Hannes

Hi,

Even though a slot delivered on queue x is not guaranteed to complete on 
completion queue x, is nearly always does (I just quickly tested on our 
new chip, and 100% of the time it is the same - I need to check with our 
hardware guys if this was only v1 of the IP).

As for firmware, our controller does not have any.

cheers,

