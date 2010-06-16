From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 07/11] qla4xxx: Added support for ISP82XX
Date: Wed, 16 Jun 2010 15:57:37 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA871286CE90F@AVEXMB1.qlogic.org>
References: <20100616205403.GA8178@sles11sp1b1.qlogic.org>
 <4C194A01.1080809@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexcashub1.qlogic.com ([198.70.193.61]:54707 "EHLO
	avexcashub1.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759243Ab0FPW5k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2010 18:57:40 -0400
In-Reply-To: <4C194A01.1080809@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: "james.bottomley@suse.de" <james.bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Wednesday, June 16, 2010 3:03 PM
>To: Vikas Chaudhary
>Cc: james.bottomley@suse.de; linux-scsi@vger.kernel.org; Ravi Anand; Karen
>Higgins
>Subject: Re: [PATCH 07/11] qla4xxx: Added support for ISP82XX
>
>On 06/16/2010 03:54 PM, Vikas Chaudhary wrote:
>>   	} else {
>>   		DEBUG2(printk("scsi%ld: Unknown mailbox status %08X\n",
>>   			      ha->host_no, mbox_status));
>>
>> -		ha->mbox_status[0] = mbox_status;
>> +		ha->mbox_status[0] = mbox_sts[0];
>>   	}
>>   }
>
>Is this right? mbox_sts[0] is not set at this point, and you get:
>
>drivers/scsi/qla4xxx/ql4_isr.c: In function 'qla4xxx_isr_decode_mailbox':
>drivers/scsi/qla4xxx/ql4_isr.c:634: warning: 'mbox_sts' may be used
>uninitialized in this function
>
>We should not hit the case though, right. Maybe in a follow up patch you
>can fix this since the rest of the patches look ok, and I do not want to
>look a them ever again :)

Thanks for pointing this out. You are right we will not hit this case.
I will send follow up patch to fix this.
