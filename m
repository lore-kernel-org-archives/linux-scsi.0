From: zhangfei <zhangfei.gao@linaro.org>
Subject: Re: [PATCH 03/25] scsi: hisi_sas: add initial bare driver
Date: Thu, 15 Oct 2015 17:28:21 +0800
Message-ID: <561F71B5.5040101@linaro.org>
References: <1444663237-238302-1-git-send-email-john.garry@huawei.com> <1444663237-238302-4-git-send-email-john.garry@huawei.com> <561F68A9.6090706@hisilicon.com> <561F707C.1070305@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f51.google.com ([209.85.220.51]:35875 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbbJOJ2b (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 05:28:31 -0400
Received: by padcn9 with SMTP id cn9so1168455pad.3
        for <linux-scsi@vger.kernel.org>; Thu, 15 Oct 2015 02:28:31 -0700 (PDT)
In-Reply-To: <561F707C.1070305@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>, Xinwei Kong <kong.kongxinwei@hisilicon.com>, James.Bottomley@HansenPartnership.com
Cc: devicetree@vger.kernel.org, arnd@arndb.de, linux-scsi@vger.kernel.org, john.garry2@mail.dcu.ie, linuxarm@huawei.com, linux-kernel@vger.kernel.com, hare@suse.de



On 10/15/2015 05:23 PM, John Garry wrote:
> On 15/10/2015 09:49, Xinwei Kong wrote:
>>
>>

>>> +++ b/drivers/scsi/hisi_sas/hisi_sas.h
>>> @@ -0,0 +1,24 @@
>>> +/*
>>> + * Copyright (c) 2015 Linaro Ltd.
>>> + * Copyright (c) 2015 Hisilicon Limited.
>>> + *
>>> + * This program is free software; you can redistribute it and/or modify
>>> + * it under the terms of the GNU General Public License as published by
>>> + * the Free Software Foundation; either version 2 of the License, or
>>> + * (at your option) any later version.

>>> +MODULE_VERSION(DRV_VERSION);
>>> +MODULE_LICENSE("GPL");
>> V2
> Can add. We do say in the header that it is v2.
>
No, should use MODULE_LICENSE("GPL");

include/linux/module.h

/*
  * The following license idents are currently accepted as indicating free
  * software modules
  *
  *      "GPL"                           [GNU Public License v2 or later]
  *      "GPL v2"                        [GNU Public License v2]

Thanks
