From: Jack Wang <xjtuwjp@gmail.com>
Subject: Re: [PATCH 3/3] pm8001: Update MAINTAINERS list
Date: Thu, 31 Jul 2014 15:13:27 +0200
Message-ID: <CAD+HZHWYi-wYVMgJpZZbTvh0+MQwvJyjEEyWAXMVgU_MPVr0Qg@mail.gmail.com>
References: <1406722063-4683-1-git-send-email-Suresh.Thiagarajan@pmcs.com>
	<1406722354.4865.58.camel@jarvis>
	<CE2C58F938F4C44EA74FFF880BAA7E5E49DC8B32@BBYEXM02.pmc-sierra.internal>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ie0-f173.google.com ([209.85.223.173]:43888 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710AbaGaNN2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jul 2014 09:13:28 -0400
Received: by mail-ie0-f173.google.com with SMTP id tr6so3669973ieb.32
        for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2014 06:13:27 -0700 (PDT)
In-Reply-To: <CE2C58F938F4C44EA74FFF880BAA7E5E49DC8B32@BBYEXM02.pmc-sierra.internal>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "thenzl@redhat.com" <thenzl@redhat.com>, Viswas G <Viswas.G@pmcs.com>, "pmchba@pmcs.com" <pmchba@pmcs.com>

If it works, then I'm fine with this, thanks.

Please add my ack if needed:

Acked-by: Jack Wang <xjtuwjp@gmail.com>

2014-07-31 14:53 GMT+02:00 Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>:
>
>
> On Wed, Jul 30, 2014 at 5:42 PM, James Bottomley <James.Bottomley@hansenpartnership.com> wrote:
>> On Wed, 2014-07-30 at 17:37 +0530, Suresh Thiagarajan wrote:
>>> From: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>>>
>>> Update pmcs mail list for pm8001 driver support
>>>
>>> Signed-off-by: Suresh Thiagarajan <Suresh.Thiagarajan@pmcs.com>
>>> ---
>>>  MAINTAINERS |    1 +
>>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index 3f2e171..a63259c 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -6987,6 +6987,7 @@ F:      drivers/scsi/pmcraid.*
>>>  PMC SIERRA PM8001 DRIVER
>>>  M:   xjtuwjp@gmail.com
>>>  M:   lindar_liu@usish.com
>>> +L:   pmchba@pmcs.com
>>
>> This list doesn't appear to work:
>
> This is fixed now. My apologies for the inconvenience.
>
> -Suresh
>>
>> <pmchba@pmcs.com>: host smtp.pmc-sierra.com[216.241.235.148] said: 550 5.1.1
>>     <pmchba@pmcs.com>: Recipient address rejected: User unknown in local
>>     recipient table (in reply to RCPT TO command)
>>
>> James
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
