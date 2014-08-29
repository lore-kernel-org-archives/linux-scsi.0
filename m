From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/5] kexec: Export kexec_in_progress
Date: Fri, 29 Aug 2014 10:38:50 -0500
Message-ID: <54009E8A.4070809@linux.vnet.ibm.com>
References: <53D6B270.5020403@linux.vnet.ibm.com> <53DF96E5.7000601@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e9.ny.us.ibm.com ([32.97.182.139]:46215 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752650AbaH2Piz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Aug 2014 11:38:55 -0400
Received: from /spool/local
	by e9.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 29 Aug 2014 11:38:54 -0400
Received: from b01cxnp23032.gho.pok.ibm.com (b01cxnp23032.gho.pok.ibm.com [9.57.198.27])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 1F75BC90042
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2014 11:38:44 -0400 (EDT)
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by b01cxnp23032.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id s7TFcqH23080492
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2014 15:38:52 GMT
Received: from d01av02.pok.ibm.com (localhost [127.0.0.1])
	by d01av02.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id s7TFcptp019847
	for <linux-scsi@vger.kernel.org>; Fri, 29 Aug 2014 11:38:52 -0400
In-Reply-To: <53DF96E5.7000601@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ebiederm@xmission.com
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Wendy Xiong <wenxiong@linux.vnet.ibm.com>, kexec@lists.infradead.org

On 08/04/2014 09:21 AM, Brian King wrote:
> On 07/28/2014 03:28 PM, Brian King wrote:
>>
>> Export kexec_in_progress for use by device drivers and other modules
>> to optimize kexec boot.
>>
>> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
>> ---
>>
>>  kernel/kexec.c |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> diff -puN kernel/kexec.c~kexec_export_in_prog kernel/kexec.c
>> --- linux/kernel/kexec.c~kexec_export_in_prog	2014-07-23 17:05:24.851887935 -0500
>> +++ linux-bjking1/kernel/kexec.c	2014-07-23 17:05:24.856887970 -0500
>> @@ -1716,3 +1716,5 @@ int kernel_kexec(void)
>>  	mutex_unlock(&kexec_mutex);
>>  	return error;
>>  }
>> +
>> +EXPORT_SYMBOL_GPL(kexec_in_progress);
> 
> Eric,
> 
> Can I get an ack on this so we can take this entire series through the SCSI tree?

Eric,

Any issues with this patch?

Thanks,

Brian


