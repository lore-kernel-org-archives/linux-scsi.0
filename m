From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] iscsi: Kconfig option for debug prints.
Date: Mon, 12 Jan 2009 17:43:59 +0200
Message-ID: <496B653F.9000409@panasas.com>
References: <496B62B8.3030402@panasas.com> <496B7248.11724.162B0F6@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.183]:45891 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493AbZALPoE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jan 2009 10:44:04 -0500
Received: by wa-out-1112.google.com with SMTP id v27so5613424wah.21
        for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2009 07:44:03 -0800 (PST)
In-Reply-To: <496B7248.11724.162B0F6@Ulrich.Windl.rkdvmks1.ngate.uni-regensburg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>

Ulrich Windl wrote:
> On 12 Jan 2009 at 17:33, Boaz Harrosh wrote:
> 
>> --- a/drivers/scsi/iscsi_tcp.h
>> +++ b/drivers/scsi/iscsi_tcp.h
>> @@ -25,6 +25,12 @@
>>  #include <scsi/libiscsi.h>
>>  #include <scsi/libiscsi_tcp.h>
>>  
>> +#if (CONFIG_ISCSI_DEBUG & 2)
>> +#define debug_tcp(fmt...) printk(KERN_INFO "tcp: " fmt)
>> +#else
>> +#define debug_tcp(fmt...)
>> +#endif
>> +
> 
> Hi!
> 
> Let me say that I feel that "tcp:" should be something like "iSCSI-TCP:", just to 
> point out that it's related to iSCSI.
> 
> Regards,
> Ulrich
> 
> 

This is unrelated to this patch. If so, it should be in another, additional patch.
I think we don't need to bother because these are in headers private to iscsi and
should never be included by any other code.

But Mike if you want I can send search-replace patch for debug_tcp/debug_scsi macros.
What do you prefer?

Thanks
Boaz
