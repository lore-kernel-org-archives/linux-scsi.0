From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH 2/5] kexec: Export kexec_in_progress
Date: Sat, 30 Aug 2014 15:02:10 -0500
Message-ID: <87wq9piw59.fsf@x220.int.ebiederm.org>
References: <53D6B270.5020403@linux.vnet.ibm.com>
	<53DF96E5.7000601@linux.vnet.ibm.com>
	<54009E8A.4070809@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:40106 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640AbaH3UCW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 30 Aug 2014 16:02:22 -0400
In-Reply-To: <54009E8A.4070809@linux.vnet.ibm.com> (Brian King's message of
	"Fri, 29 Aug 2014 10:38:50 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, kexec@lists.infradead.org

Brian King <brking@linux.vnet.ibm.com> writes:

> On 08/04/2014 09:21 AM, Brian King wrote:
>> On 07/28/2014 03:28 PM, Brian King wrote:
>>>
>>> Export kexec_in_progress for use by device drivers and other modules
>>> to optimize kexec boot.
>>>
>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>> ---
>>>
>>>  kernel/kexec.c |    2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
>>> --- linux/kernel/kexec.c~kexec_export_in_prog	2014-07-23 17:05:24.851887935 -0500
>>> +++ linux-bjking1/kernel/kexec.c	2014-07-23 17:05:24.856887970 -0500
>>> @@ -1716,3 +1716,5 @@ int kernel_kexec(void)
>>>  	mutex_unlock(&kexec_mutex);
>>>  	return error;
>>>  }
>>> +
>>> +EXPORT_SYMBOL_GPL(kexec_in_progress);
>> 
>> Eric,
>> 
>> Can I get an ack on this so we can take this entire series through the SCSI tree?
>
> Eric,
>
> Any issues with this patch?

No huge issues except that patch description is largely uniformitive and
actually wrong.  kexec_in_progress is never set at boot/kernel startup.

Eric
