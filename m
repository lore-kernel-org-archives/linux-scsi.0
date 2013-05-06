From: merez@codeaurora.org
Subject: Re: [PATCH 3/3] scsi: ufs: add support for query requests
Date: Mon, 6 May 2013 03:41:39 -0700
Message-ID: <0cca1077de2749f55ba782bd717c18be.squirrel@www.codeaurora.org>
References: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
    <1367495736-8927-4-git-send-email-santoshsy@gmail.com>
    <1367605900.5981.47.camel@dabdike>
    <CALMYJDubJi=xm+6937cyGpw+MhS1qNNZaVTt1a2HOb0NfAYJ4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:50691 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753787Ab3EFKlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 06:41:39 -0400
In-Reply-To: <CALMYJDubJi=xm+6937cyGpw+MhS1qNNZaVTt1a2HOb0NfAYJ4w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Santosh Y <santoshsy@gmail.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Dolev Raviv <draviv@codeaurora.org>

Tested-by: Maya Erez <merez@codeaurora.org>

>>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>>> index 35faf24..82417d6 100644
>>> --- a/drivers/scsi/ufs/Kconfig
>>> +++ b/drivers/scsi/ufs/Kconfig
>>> @@ -35,6 +35,7 @@
>>>  config SCSI_UFSHCD
>>>       tristate "Universal Flash Storage Controller Driver Core"
>>>       depends on SCSI
>>> +     default y
>>>       ---help---
>>>       This selects the support for UFS devices in Linux, say Y and make
>>>         sure that you know the name of your UFS host adapter (the card
>>
>> I don't think you want to force this on in every configuration since
>> it's only appropriate to non server/desktop.  I stripped this hunk.
>>
>
> Hi James,
>
> Please apply the patch without the particular change or you can apply
> the latest patch sent by Dolev -
> http://marc.info/?l=linux-scsi&m=136774922024179&w=1.
>
> Thanks,
> Santosh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


-- 
Maya Erez
QUALCOMM ISRAEL, on behalf of Qualcomm Innovation Center, Inc. is a member
of Code Aurora Forum, hosted by The Linux Foundation

