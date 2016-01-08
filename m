From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 01/23] devicetree: bindings: hisi_sas: add v2 HW bindings
Date: Fri, 8 Jan 2016 15:34:37 +0000
Message-ID: <568FD70D.1090303@huawei.com>
References: <1452262542-64589-1-git-send-email-john.garry@huawei.com>
 <1452262542-64589-2-git-send-email-john.garry@huawei.com>
 <20160108145256.GG3097@leverpostej> <568FD281.4050207@huawei.com>
 <20160108151934.GA32692@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([119.145.14.66]:8876 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755175AbcAHPft (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jan 2016 10:35:49 -0500
In-Reply-To: <20160108151934.GA32692@leverpostej>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Rutland <mark.rutland@arm.com>
Cc: JBottomley@odin.com, martin.petersen@oracle.com, robh+dt@kernel.org, pawel.moll@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, arnd@arndb.de, devicetree@vger.kernel.org


>>>> +Optional main node properties:
>>>> + - am-max-trans : limit controller for am max transmissions
>>>
>>> Is this a boolean? Number?
>>>
>>
>> This is a boolean. It is for dealing with a quirk in the chipset: an
>> instance of the controller in the hip06 chipset requires registers
>> set with a different init value.
>
> Ok. I think the property at needs a better description for that.
>
> It's not clear to me how "limit controller for am max transmissions"
> maps to writing a specific value to some registers, but I don't know
> much about SAS.
>
> Is this some well-known thing, or values specific to hip06?
>
> Thanks,
> Mark.
>

This is a specific issue for hip06 chipset. There is a bug in the HW on 
hip06 where controller #1 has to set to 2 registers to non-default 
values to limit "am-max-transmissions". This would not be a common 
SAS/SCSI controller property and is specific to our HW.

Thanks,
John

