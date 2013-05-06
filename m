From: Santosh Y <santoshsy@gmail.com>
Subject: Re: [PATCH 3/3] scsi: ufs: add support for query requests
Date: Mon, 6 May 2013 09:56:08 +0530
Message-ID: <CALMYJDubJi=xm+6937cyGpw+MhS1qNNZaVTt1a2HOb0NfAYJ4w@mail.gmail.com>
References: <1367495736-8927-1-git-send-email-santoshsy@gmail.com>
 <1367495736-8927-4-git-send-email-santoshsy@gmail.com> <1367605900.5981.47.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37847 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752461Ab3EFE0a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 00:26:30 -0400
Received: by mail-bk0-f52.google.com with SMTP id q16so1397028bkw.11
        for <linux-scsi@vger.kernel.org>; Sun, 05 May 2013 21:26:29 -0700 (PDT)
In-Reply-To: <1367605900.5981.47.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, Dolev Raviv <draviv@codeaurora.org>

>> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
>> index 35faf24..82417d6 100644
>> --- a/drivers/scsi/ufs/Kconfig
>> +++ b/drivers/scsi/ufs/Kconfig
>> @@ -35,6 +35,7 @@
>>  config SCSI_UFSHCD
>>       tristate "Universal Flash Storage Controller Driver Core"
>>       depends on SCSI
>> +     default y
>>       ---help---
>>       This selects the support for UFS devices in Linux, say Y and make
>>         sure that you know the name of your UFS host adapter (the card
>
> I don't think you want to force this on in every configuration since
> it's only appropriate to non server/desktop.  I stripped this hunk.
>

Hi James,

Please apply the patch without the particular change or you can apply
the latest patch sent by Dolev -
http://marc.info/?l=linux-scsi&m=136774922024179&w=1.

Thanks,
Santosh
