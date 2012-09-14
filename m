From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: Re: [PATCH 42/42] qla2xxx: Update version number to 8.04.00.07-k.
Date: Fri, 14 Sep 2012 13:27:02 -0400
Message-ID: <alpine.WNT.2.00.1209141323310.7024@N5102REMCQXM4BS.qlogic.org>
References: <1345659696-3670-1-git-send-email-chad.dupuis@qlogic.com>  <1345659696-3670-43-git-send-email-chad.dupuis@qlogic.com> <1347643236.2450.19.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:28882
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755640Ab2INR1J convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 13:27:09 -0400
In-Reply-To: <1347643236.2450.19.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



On Fri, 14 Sep 2012, James Bottomley wrote:

> On Wed, 2012-08-22 at 14:21 -0400, Chad Dupuis wrote:
>> Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
>> Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
>> ---
>>  drivers/scsi/qla2xxx/qla_version.h |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/scsi/qla2xxx/qla_version.h b/drivers/scsi/qla2xxx/qla_version.h
>> index e6a5270..cfe934e 100644
>> --- a/drivers/scsi/qla2xxx/qla_version.h
>> +++ b/drivers/scsi/qla2xxx/qla_version.h
>> @@ -7,9 +7,9 @@
>>  /*
>>   * Driver version
>>   */
>> -#define QLA2XXX_VERSION      "8.04.00.03-k"
>> +#define QLA2XXX_VERSION      "8.04.00.07-k"
>>
>>  #define QLA_DRIVER_MAJOR_VER        8
>>  #define QLA_DRIVER_MINOR_VER        4
>>  #define QLA_DRIVER_PATCH_VER        0
>> -#define QLA_DRIVER_BETA_VER 3
>> +#define QLA_DRIVER_BETA_VER 0
>
> Shouldn't this be 7 not 0?
>
> James
>

Hi James,

The original change to 3 was incorrect so it was changed back to 0.

--Chad

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.

