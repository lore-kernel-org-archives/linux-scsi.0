From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: Re: [scsi:for-next 14/27] drivers/scsi/qla2xxx/qla_os.c:364
 qla2x00_free_req_que() info: redundant null check on req->outstanding_cmds
 calling kfree()
Date: Wed, 30 Jan 2013 05:25:24 +0000
Message-ID: <F5D084D6342F9B479C34599BB0A03E4D04596A@AVMB1.qlogic.org>
References: <1359428377.2408.20.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:45399
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750732Ab3A3F0E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jan 2013 00:26:04 -0500
In-Reply-To: <1359428377.2408.20.camel@dabdike>
Content-Language: en-US
Content-ID: <BBA96FC07B10FC45ADAB67D9F88AD689@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, kbuild test robot <fengguang.wu@intel.com>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



>On Mon, 2012-12-17 at 20:45 +0800, kbuild test robot wrote:
>> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git
>>for-next
>> head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
>> commit: 99cc149bbdd78a3f18c6b366e1c239f62d59d096 [14/27] [SCSI]
>>qla2xxx: Determine the number of outstanding commands based on available
>>resources.
>>
>>
>> smatch warnings:
>>
>> + drivers/scsi/qla2xxx/qla_os.c:364 qla2x00_free_req_que() info:
>>redundant null check on req->outstanding_cmds calling kfree()
>>   drivers/scsi/qla2xxx/qla_os.c:686 qla2xxx_queuecommand() error:
>>potential NULL dereference 'rport'.
>
>I flushed all the outstanding qla2xxx patches from the SCSI tree.
>Please fix these issues and resubmit.

Hi James,

We will be re-submitting the patches soon.

Thanks,
~Saurav
>
>Thanks,
>
>James
>
>
>--
>To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


________________________________

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

