Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18BECC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 08:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231966AbiGZIjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 04:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbiGZIjV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 04:39:21 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF852F380
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 01:39:20 -0700 (PDT)
X-UUID: 3133d61a57ff4b619250d03aca85d93f-20220726
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:590be214-f1c0-431a-bc8a-22e72bb671f9,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:50
X-CID-INFO: VERSION:1.1.8,REQID:590be214-f1c0-431a-bc8a-22e72bb671f9,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:0,EDM:0,RT:0,SF:45,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:50
X-CID-META: VersionHash:0f94e32,CLOUDID:bcf085b3-06d2-48ef-b2dd-540836705165,C
        OID:6ffcf5d0ebf1,Recheck:0,SF:28|17|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 3133d61a57ff4b619250d03aca85d93f-20220726
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 925758928; Tue, 26 Jul 2022 16:39:15 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 26 Jul 2022 16:39:15 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 26 Jul 2022 16:39:15 +0800
Subject: Re: [PATCH v1] ufs: core: change comment message to popular format
To:     Bart Van Assche <bvanassche@acm.org>, <stanley.chu@mediatek.com>,
        <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>
CC:     <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220725131558.13219-1-peter.wang@mediatek.com>
 <e962c613-7bdc-99f3-4273-b91beec614ee@acm.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <e9240424-4e56-b705-c336-d2fdb38b9fcb@mediatek.com>
Date:   Tue, 26 Jul 2022 16:39:14 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <e962c613-7bdc-99f3-4273-b91beec614ee@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/26/22 12:41 AM, Bart Van Assche wrote:
> On 7/25/22 06:15, peter.wang@mediatek.com wrote:
>> From: Peter Wang <peter.wang@mediatek.com>
>>
>> Some editor cannot display ‘0’ ‘1’ in correct format.
>> Change it to '0' '1' for most editor can display.
>
> As far as I know checkpatch accepts non-ASCII UTF-8 characters. Using 
> this encoding is essential to spell non-English names correctly in 
> source files. I don't think it's feasible nor desirable to eliminate 
> all non-ASCII UTF-8 from kernel source code files. Maybe this means 
> that it's time to switch to another editor?
>
> Thanks,
>
> Bart.

Hi Bart,

Yes, I have switch another editor when I modify this file.
Non-ASCII UTF-8 characters is not forbidden to use, but in this case, 
'0' and '1' is not required for people to understand this comment.

Thanks.
Peter


