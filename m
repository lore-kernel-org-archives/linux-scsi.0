From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] kexec: Export kexec_in_progress
Date: Tue, 02 Sep 2014 14:46:03 -0500
Message-ID: <54061E7B.4080803@linux.vnet.ibm.com>
References: <53D6B270.5020403@linux.vnet.ibm.com> <53DF96E5.7000601@linux.vnet.ibm.com>	<54009E8A.4070809@linux.vnet.ibm.com> <87wq9piw59.fsf@x220.int.ebiederm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58821 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752455AbaIBTqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2014 15:46:13 -0400
Received: from /spool/local
	by e8.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Tue, 2 Sep 2014 15:46:12 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp02.pok.ibm.com (Postfix) with ESMTP id 553236E804A
	for <linux-scsi@vger.kernel.org>; Tue,  2 Sep 2014 15:45:58 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s82Jk9Nm9372006
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2014 19:46:09 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s82Jk6YU013946
	for <linux-scsi@vger.kernel.org>; Tue, 2 Sep 2014 15:46:09 -0400
In-Reply-To: <87wq9piw59.fsf@x220.int.ebiederm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, kexec@lists.infradead.org

On 08/30/2014 03:02 PM, Eric W. Biederman wrote:
> Brian King <brking@linux.vnet.ibm.com> writes:
> 
>> On 08/04/2014 09:21 AM, Brian King wrote:
>>> On 07/28/2014 03:28 PM, Brian King wrote:
>>>>
>>>> Export kexec_in_progress for use by device drivers and other modules
>>>> to optimize kexec boot.
>>>>
>>>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>>>> ---
>>>>
>>>>  kernel/kexec.c |    2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
>>>> --- linux/kernel/kexec.c~kexec_export_in_prog	2014-07-23 17:05:24.851887935 -0500
>>>> +++ linux-bjking1/kernel/kexec.c	2014-07-23 17:05:24.856887970 -0500
>>>> @@ -1716,3 +1716,5 @@ int kernel_kexec(void)
>>>>  	mutex_unlock(&kexec_mutex);
>>>>  	return error;
>>>>  }
>>>> +
>>>> +EXPORT_SYMBOL_GPL(kexec_in_progress);
>>>
>>> Eric,
>>>
>>> Can I get an ack on this so we can take this entire series through the SCSI tree?
>>
>> Eric,
>>
>> Any issues with this patch?
> 
> No huge issues except that patch description is largely uniformitive and
> actually wrong.  kexec_in_progress is never set at boot/kernel startup.

Good point. How about this instead:

Export kexec_in_progress for use by device drivers and other modules
to optimize shutdown handling during kexec.

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


