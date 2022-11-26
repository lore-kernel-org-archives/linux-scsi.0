Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 282B2C43217
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 01:16:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230092AbiKZBQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 20:16:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiKZBQF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 20:16:05 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEDC92FFFE;
        Fri, 25 Nov 2022 17:16:00 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.30.67.153])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4NJv1k3G0Gz4f3tpW;
        Sat, 26 Nov 2022 09:15:54 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP4 (Coremail) with SMTP id gCh0CgC329jJaIFjxIilBA--.64S3;
        Sat, 26 Nov 2022 09:15:55 +0800 (CST)
Subject: Re: Why is MEGASAS_SAS_QD set to 256?
To:     John Garry <john.g.garry@oracle.com>,
        Yu Kuai <yukuai1@huaweicloud.com>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <1c4d66ca-fe1a-3d1a-d7f9-4981d2fc9eb1@huaweicloud.com>
 <e11cdb17-053c-390c-9c48-36790eb70cc5@oracle.com>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <2b89210a-222c-a919-ab5b-c76830308f92@huaweicloud.com>
Date:   Sat, 26 Nov 2022 09:15:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <e11cdb17-053c-390c-9c48-36790eb70cc5@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: gCh0CgC329jJaIFjxIilBA--.64S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Zw17tFW8XFWDCFWfZr4UXFb_yoW8Cr1rpa
        y8ZF4Yk34UW3W0kw4ftw4DXa48t3W8Jas5KF4UtayDJa909F1jvr45XrWYgr97Xrs3G3Wj
        vws0qFWUuFyqqFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU9Y14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
        rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
        1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
        6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
        Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
        I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
        4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
        c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCT
        nIWIevJa73UjIFyTuYvjfUoOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

在 2022/11/25 20:33, John Garry 写道:
> On 24/11/2022 03:45, Yu Kuai wrote:
>> Hi,
>>
>> While upgrading kernel from 4.19 to 5.10, I found that fio 1 thread 4k
>> sequential io performance is dropped(160Mib -> 100 Mib), root cause is
>> that queue_depth is changed from 64 to 256.
>>
>> commit 6e73550670ed1c07779706bb6cf61b99c871fc42
>> scsi: megaraid_sas: Update optimal queue depth for SAS and NVMe devices
>>
>> diff --git a/drivers/scsi/megaraid/megaraid_sas.h 
>> b/drivers/scsi/megaraid/megaraid_sas.h
>> index bd8184072bed..ddfbe6f6667a 100644
>> --- a/drivers/scsi/megaraid/megaraid_sas.h
>> +++ b/drivers/scsi/megaraid/megaraid_sas.h
>> @@ -2233,9 +2233,9 @@ enum MR_PD_TYPE {
>>
>>   /* JBOD Queue depth definitions */
>>   #define MEGASAS_SATA_QD        32
>> -#define MEGASAS_SAS_QD 64
>> +#define MEGASAS_SAS_QD 256
>>   #define MEGASAS_DEFAULT_PD_QD  64
>> -#define MEGASAS_NVME_QD                32
>> +#define MEGASAS_NVME_QD        64
>>
>>
>> And with the default nr_requests 256, 256 queue_depth will make the
>> elevator has no effect, specifically io can't be merged in this test
>> case. Hence it doesn't make sense to me to set default queue_depth to
>> 256.
>>
>> Is there any reason why MEGASAS_SAS_QD is changed to 64?
>>
>> Thanks,
>> Kuai
>>
> 
> Which type of drive do you use?

SAS SSDs

BTW, I also test with nvme as well, the default elevator is deadline and
queue_depth seems too small, and performance is far from optimal.

Current default values don't seem good to me... 😒

Thanks,
Kuai
> 
> JFYI, in case missed, there was this discussion on SCSI queue depth a 
> while ago:
> https://lore.kernel.org/linux-scsi/4b50f067-a368-2197-c331-a8c981f5cd02@huawei.com/ 
> 
> 
> Thanks,
> John
> 
> 
> .
> 

