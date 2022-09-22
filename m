Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF477C6FA8B
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Sep 2022 08:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbiIVIuA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Sep 2022 04:50:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiIVIt7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Sep 2022 04:49:59 -0400
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314204BD33
        for <linux-scsi@vger.kernel.org>; Thu, 22 Sep 2022 01:49:58 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R231e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046060;MF=kanie@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VQRrHPd_1663836594;
Received: from 30.178.82.244(mailfrom:kanie@linux.alibaba.com fp:SMTPD_---0VQRrHPd_1663836594)
          by smtp.aliyun-inc.com;
          Thu, 22 Sep 2022 16:49:55 +0800
Message-ID: <52172013-ca22-0d4c-be64-8ba3516dbd7b@linux.alibaba.com>
Date:   Thu, 22 Sep 2022 16:49:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH 0/5] scsi: megaraid_sas: some bug fixes and cod cleanup
From:   Guixin Liu <kanie@linux.alibaba.com>
To:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        shivasharan.srikanteshwara@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <1663145283-4872-1-git-send-email-kanie@linux.alibaba.com>
 <7b3ba1bd-789e-f4e9-7cc4-90071e494f67@linux.alibaba.com>
In-Reply-To: <7b3ba1bd-789e-f4e9-7cc4-90071e494f67@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Gentle ping...

I think both "scsi: megaraid_sas: correct the parameter of 
scsi_device_lookup" and

"scsi: megaraid_sas: move megasas_dbg_lvl init to megasas_init " are 
importent issue.

Best regards,

Guixin Liu

在 2022/9/19 10:35, Guixin Liu 写道:
> Hi，
>
> Gentle ping.
>
> Best regards,
>
> Guixin Liu
>
> 在 2022/9/14 16:47, Guixin Liu 写道:
>> *** BLURB HERE ***
>>
>> Hi guys,
>>
>> This series has bug fix and a few simple cleanups,
>> please review.
>>
>> Guixin Liu (5):
>>    scsi: megaraid_sas: correct the parameter of scsi_device_lookup
>>    scsi: megaraid_sas: correct an error message
>>    scsi: megaraid_sas: simplify the megasas_update_device_list
>>    scsi: megaraid_sas: remove unnecessary memset
>>    scsi: megaraid_sas: move megasas_dbg_lvl init to megasas_init
>>
>>   drivers/scsi/megaraid/megaraid_sas_base.c | 27 
>> ++++++++-------------------
>>   1 file changed, 8 insertions(+), 19 deletions(-)
>>
