From: ygardi@codeaurora.org
Subject: Re: [PATCH v5 15/15] scsi: ufs-qcom: set PA_Local_TX_LCC_Enable
 before link startup
Date: Sun, 6 Mar 2016 11:57:34 -0000
Message-ID: <b608d17438fc7372cb2617e208be5e6d.squirrel@us.codeaurora.org>
References: <1456666367-11418-1-git-send-email-ygardi@codeaurora.org>
    <1456666367-11418-16-git-send-email-ygardi@codeaurora.org>
    <56D54BC2.70902@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:33801 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbcCFL5h (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 6 Mar 2016 06:57:37 -0500
In-Reply-To: <56D54BC2.70902@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Yaniv Gardi <ygardi@codeaurora.org>, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, santoshsy@gmail.com, linux-scsi-owner@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jbottomley@odin.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

> On 02/28/2016 09:32 PM, Yaniv Gardi wrote:
>> Some UFS devices (and may be host) have issues if LCC is
>> enabled. So we are setting PA_Local_TX_LCC_Enable to 0
>> before link startup which will make sure that both host
>> and device TX LCC are disabled once link startup is
>> completed.
>>
>> This change also:
>> - enables the device ref clock before changing to HS mode
>>   and disables it if entered to PWM mode
>> - adds printouts of testbus debug registers
>>
> Please make that in two patches; these issues are unrelated and will
> just confuse users if one ever need to dig through the git log.
>

done. in V6 this patch will be divided into 3 patches.
1. LX_LCC
2. device ref clock
3. debug printouts

thanks,
Yaniv

> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke		      zSeries & Storage
> hare@suse.de			      +49 911 74053 688
> SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
> GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
