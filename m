From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Subject: RE: [PATCH 04/13] qla4xxx: cleanup DDB relogin logic during
 initialization
Date: Tue, 15 Mar 2011 02:42:19 -0700
Message-ID: <5E4F49720D0BAD499EE1F01232234BA872263B177D@AVEXMB1.qlogic.org>
References: <5E4F49720D0BAD499EE1F01232234BA872263B150A@AVEXMB1.qlogic.org>
 <4D7E8EE2.7070107@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:39899
	"EHLO VA3EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752047Ab1COJma convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Mar 2011 05:42:30 -0400
In-Reply-To: <4D7E8EE2.7070107@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Lalit Chandivade <lalit.chandivade@qlogic.com>, Ravi Anand <ravi.anand@qlogic.com>, Karen Higgins <karen.higgins@qlogic.com>

>-----Original Message-----
>From: Mike Christie [mailto:michaelc@cs.wisc.edu]
>Sent: Tuesday, March 15, 2011 3:26 AM
>To: Vikas Chaudhary
>Cc: James Bottomley; linux-scsi@vger.kernel.org; Lalit Chandivade; Ravi
>Anand; Karen Higgins
>Subject: Re: [PATCH 04/13] qla4xxx: cleanup DDB relogin logic during
>initialization
>
>On 03/14/2011 12:24 AM, Vikas Chaudhary wrote:
>> diff --git a/drivers/scsi/qla4xxx/ql4_init.c
>b/drivers/scsi/qla4xxx/ql4_init.c
>> index 22fc57e..bf1c30b 100644
>> --- a/drivers/scsi/qla4xxx/ql4_init.c
>> +++ b/drivers/scsi/qla4xxx/ql4_init.c
>> @@ -723,13 +723,38 @@ int qla4_is_relogin_allowed(struct scsi_qla_host
>*ha, uint32_t conn_err)
>>          return relogin;
>>   }
>>
>> +static void qla4xxx_flush_AENS(struct scsi_qla_host *ha)
>> +{
>
>I think it is ok for now since the patch is moving the old function, but
>in some future coding style cleanup patch could you fix mixed cases like
>this. So it would be qla4xxx_flush_aens instead of _AENS. It then
>matches the kernel coding style and matches functions like
>qla4xxx_process_aen.
>

Ok, we will take care from next time.


This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

