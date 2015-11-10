From: Rob Herring <robh@kernel.org>
Subject: Re: [PATCH v3 02/32] devicetree: bindings: scsi: HiSi SAS
Date: Tue, 10 Nov 2015 07:16:03 -0600
Message-ID: <CAL_JsqLbWWSLbe+7T=qbp-Y2DMngeUf3nnxytb8=+ceYxUcgrA@mail.gmail.com>
References: <1447086757-147706-1-git-send-email-john.garry@huawei.com>
 <1447086757-147706-3-git-send-email-john.garry@huawei.com>
 <20151109180133.GA23100@rob-hp-laptop> <5641D087.8050502@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:60056 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042AbbKJNQ0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Nov 2015 08:16:26 -0500
In-Reply-To: <5641D087.8050502@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: John Garry <john.garry@huawei.com>
Cc: "JBottomley@odin.com" <JBottomley@odin.com>, "pawel.moll@arm.com" <pawel.moll@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "galak@codeaurora.org" <galak@codeaurora.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "john.garry2@mail.dcu.ie" <john.garry2@mail.dcu.ie>, "hare@suse.de" <hare@suse.de>, "xuwei (O)" <xuwei5@hisilicon.com>, "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>

On Tue, Nov 10, 2015 at 5:09 AM, John Garry <john.garry@huawei.com> wrote:
> On 09/11/2015 18:01, Rob Herring wrote:
>>
>> On Tue, Nov 10, 2015 at 12:32:07AM +0800, John Garry wrote:
>>>
>>> Add devicetree bindings for HiSilicon SAS driver.
>>>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> Signed-off-by: Zhangfei Gao <zhangfei.gao@linaro.org>
>>> ---
>>>   .../devicetree/bindings/scsi/hisilicon-sas.txt     | 81
>>> ++++++++++++++++++++++
>>>   1 file changed, 81 insertions(+)
>>>   create mode 100644
>>> Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>> b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>> new file mode 100644
>>> index 0000000..2333cc3
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>>> @@ -0,0 +1,81 @@
>>> +* HiSilicon SAS controller
>>> +
>>> +The HiSilicon SAS controller supports SAS/SATA.
>>> +
>>> +Main node required properties:
>>> +  - compatible : value should be as follows:
>>> +       (a) "hisilicon,sas-controller-v1" for v1 of HiSilicon SAS
>>> controller IP
>>
>>
>> Please do a more specific compatible string with the SOC part number.
>> Same versions of IP blocks can have different integration/process
>> features/bugs.
>>
>
> How about "hisilicon,hip05-sas-v1"?

That's fine.

Rob
