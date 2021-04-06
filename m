Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B7BC433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:40:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DF5F8610A5
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Apr 2021 06:40:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234031AbhDFGkR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Apr 2021 02:40:17 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:15604 "EHLO
        szxga04-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232385AbhDFGkR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Apr 2021 02:40:17 -0400
Received: from DGGEMS411-HUB.china.huawei.com (unknown [172.30.72.59])
        by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4FDyWp00zzz19KLD;
        Tue,  6 Apr 2021 14:37:57 +0800 (CST)
Received: from [127.0.0.1] (10.40.192.131) by DGGEMS411-HUB.china.huawei.com
 (10.3.19.211) with Microsoft SMTP Server id 14.3.498.0; Tue, 6 Apr 2021
 14:40:01 +0800
Subject: Re: [PATCH v1 2/2] scsi: pm8001: clean up for open brace
To:     Bart Van Assche <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linuxarm@huawei.com>
References: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
 <1617354522-17113-3-git-send-email-luojiaxing@huawei.com>
 <614f4c0f-deaa-ad3a-09d1-ac6e8ec2d143@acm.org>
From:   luojiaxing <luojiaxing@huawei.com>
Message-ID: <400a9958-dffc-7e09-6bbb-33666c991415@huawei.com>
Date:   Tue, 6 Apr 2021 14:40:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <614f4c0f-deaa-ad3a-09d1-ac6e8ec2d143@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.40.192.131]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2021/4/3 0:03, Bart Van Assche wrote:
> On 4/2/21 2:08 AM, Luo Jiaxing wrote:
>> -static struct flash_command flash_command_table[] =
>> -{
>> +static struct flash_command flash_command_table[] = {
>>        {"set_nvmd",    FLASH_CMD_SET_NVMD},
>>        {"update",      FLASH_CMD_UPDATE},
>>        {"",            FLASH_CMD_NONE} /* Last entry should be NULL. */
> Can 'flash_command_table' be declared const?


Sure


>
>> -static struct error_fw flash_error_table[] =
>> -{
>> +static struct error_fw flash_error_table[] = {
>>        {"Failed to open fw image file",	FAIL_OPEN_BIOS_FILE},
>>        {"image header mismatch",		FLASH_UPDATE_HDR_ERR},
>>        {"image offset mismatch",		FLASH_UPDATE_OFFSET_ERR},
> Can 'flash_error_table' be declared const?


Sure


Thanks

Jiaxing


>
> Thanks,
>
> Bart.
>
> .
>

