From: Alim Akhtar <alim.akhtar@samsung.com>
Subject: Re: [PATCH v3 12/13] scsi: ufs-exynos: add UFS host support for Exynos
 SoCs
Date: Tue, 13 Oct 2015 17:15:39 +0530
Message-ID: <561CEEE3.7060401@samsung.com>
References: <1443686970-28104-1-git-send-email-alim.akhtar@samsung.com>
 <2228323.jdbqnSKW75@wuerfel> <561CE8CB.9010102@samsung.com>
 <6499659.hVBcEphJIR@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-reply-to: <6499659.hVBcEphJIR@wuerfel>
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org



On 10/13/2015 05:08 PM, Arnd Bergmann wrote:
> On Tuesday 13 October 2015 16:49:39 Alim Akhtar wrote:
>>>> diff --git a/drivers/scsi/ufs/ufs-exynos.h b/drivers/scsi/ufs/ufs-exynos.h
>>>> new file mode 100644
>>>> index 0000000..58aa714
>>>> --- /dev/null
>>>> +++ b/drivers/scsi/ufs/ufs-exynos.h
>>>> @@ -0,0 +1,463 @@
>>>> +/*
>>>> + * UFS Host Controller driver for Exynos specific extensions
>>>> + *
>>>> + * Copyright (C) 2014-2015 Samsung Electronics Co., Ltd.
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License as published by
>>>> + * the Free Software Foundation; either version 2 of the License, or
>>>> + * (at your option) any later version.
>>>> + */
>>>> +
>>>> +#ifndef _UFS_EXYNOS_H_
>>>> +#define _UFS_EXYNOS_H_
>>>
>>> You have a lot of things in this header that are only used in one of the
>>> .c files, so just move them there and make the header as small as possible.
>>>
>> hmm..these are mostly the registers defines, will removes the one which
>> are not being used as of now.
>> Do you think I should sill move them to .c file?
>>
>
> Yes. No need to remove the unused register definitions, just don't put
> them into a separate header if they are only used in one place.
>
Ok will do that in v4.
Thanks.
> 	Arnd
>
