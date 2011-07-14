From: Giridhar Malavali <giridhar.malavali@qlogic.com>
Subject: Re: [PATCH 0/3] qla2xxx: Updates for scsi misc 3.0.
Date: Thu, 14 Jul 2011 10:36:09 -0700
Message-ID: <CA4476B1.21CBD%giridhar.malavali@qlogic.com>
References: <1310664551.15805.1.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:3828
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932169Ab1GNRgS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Jul 2011 13:36:18 -0400
In-Reply-To: <1310664551.15805.1.camel@mulgrave>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>>

>On Thu, 2011-07-14 at 10:07 -0700, giridhar.malavali@qlogic.com wrote:
>> From: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> 
>> James,
>> 
>> Please apply these patches.
>> 
>> The patch 1/3 has couple of warnings w.r.t KERN_facility level with
>>printk.
>> 
>> WARNING: printk() should include KERN_ facility level
>> 
>> Using KERN facility in printk will print each buffer information in new
>>line causing
>> unreadable log messages.
>> 
>> Here is an example
>> 
>> With KERN facility
>> Mar 23 10:05:37 linux-dcaw kernel: qla2xxx [0000:18:00.6]4:1102:
>> Mar 23 10:05:37 linux-dcaw kernel: 42
>> Mar 23 10:05:37 linux-dcaw kernel:
>> Mar 23 10:05:37 linux-dcaw kernel: 00
>> 
>> Without KERN facility
>> Mar 21 13:07:35 linux-dcaw kernel: qla2xxx [0000:18:00.7]37:1102: 48
>>00  00  00  5b  f2  00
>> 
>> Hope this should be fine since this is not an error.
>> 
>> -- Giridhar
>> Saurav Kashyap (3):
>>   qla2xxx: Basic infrastructure for dynamic logging.
>>   qla2xxx: Code changes to support new dynamic logging infrastructure.
>
>This patch is missing (for the second time).  It's either too big or is
>getting caught in vger's spam filters somehow.

Thanks for the information. I will resubmit the patches breaking them
further. I think the patch is too big.

-- Giri

>
>James
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


