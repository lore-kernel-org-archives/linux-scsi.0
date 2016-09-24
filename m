From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/3] devicetree: bindings: scsi: hisi_sas hip07 support
Date: Sat, 24 Sep 2016 19:51:17 +0100
Message-ID: <397f3957-ed99-d7e9-b808-a299d442b7dd@huawei.com>
References: <1474368540-186535-1-git-send-email-john.garry@huawei.com>
 <1474368540-186535-2-git-send-email-john.garry@huawei.com>
 <20160923183641.GA27636@rob-hp-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:46198 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760355AbcIXSwN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 24 Sep 2016 14:52:13 -0400
In-Reply-To: <20160923183641.GA27636@rob-hp-laptop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Herring <robh@kernel.org>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, devicetree@vger.kernel.org, mark.rutland@arm.com, linuxarm@huawei.com, zhangfei.gao@linaro.org, xuwei5@hisilicon.com, john.garry2@mail.dcu.ie, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, hare@suse.com, Xiang Chen <chenxiang66@hisilicon.com>

On 23/09/2016 19:36, Rob Herring wrote:
> On Tue, Sep 20, 2016 at 06:48:58PM +0800, John Garry wrote:
>> Add support for hip07 chipset to bindings.
>>
>> Chipset hip07 has v2 hw.
>>
>> The sas-v2 quirk amt is expanded to cover hip07.
>>
>> Signed-off-by: John Garry <john.garry@huawei.com>
>> Signed-off-by: Xiang Chen <chenxiang66@hisilicon.com>
>> ---
>>  Documentation/devicetree/bindings/scsi/hisilicon-sas.txt | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> index bf2411f..e604527 100644
>> --- a/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> +++ b/Documentation/devicetree/bindings/scsi/hisilicon-sas.txt
>> @@ -6,6 +6,7 @@ Main node required properties:
>>    - compatible : value should be as follows:
>>  	(a) "hisilicon,hip05-sas-v1" for v1 hw in hip05 chipset
>>  	(b) "hisilicon,hip06-sas-v2" for v2 hw in hip06 chipset
>> +	(c) "hisilicon,hip07-sas-v2" for v2 hw in hip07 chipset
>>    - sas-addr : array of 8 bytes for host SAS address
>>    - reg : Address and length of the SAS register
>>    - hisilicon,sas-syscon: phandle of syscon used for sas control
>> @@ -47,7 +48,7 @@ Main node required properties:
>>  			increasing order.
>>
>>  Optional main node properties:
>> - - hip06-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
>> + - hip06/7-sas-v2-quirk-amt : when set, indicates that the v2 controller has the
>
> Just use the existing property name for hip07.

OK, but you mean existing hip06 property (hip06-sas-v2-quirk-amt), right?

>
>>  			    "am-max-transmissions" limitation.
>>
>>  Example:
>> --
>> 1.9.1
>>
>
> .
>


