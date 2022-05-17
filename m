Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9527CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 17 May 2022 08:18:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbiEQISh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 May 2022 04:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242847AbiEQISA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 May 2022 04:18:00 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8277448E59
        for <linux-scsi@vger.kernel.org>; Tue, 17 May 2022 01:17:15 -0700 (PDT)
X-UUID: 4552c4d236fd46168dcbcce31135d90d-20220517
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:09ebaeb8-63fa-4125-bcf7-d6e690f245f3,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_Ham,AC
        TION:release,TS:49
X-CID-INFO: VERSION:1.1.5,REQID:09ebaeb8-63fa-4125-bcf7-d6e690f245f3,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:-5,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_HamU,ACT
        ION:release,TS:49
X-CID-META: VersionHash:2a19b09,CLOUDID:8aae77e2-edbf-4bd4-8a34-dfc5f7bb086d,C
        OID:7b9bcad43e31,Recheck:0,SF:28|16|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:0,File:nil,QS:0,BEC:nil
X-UUID: 4552c4d236fd46168dcbcce31135d90d-20220517
Received: from mtkcas11.mediatek.inc [(172.21.101.40)] by mailgw01.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 349737655; Tue, 17 May 2022 16:17:11 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n2.mediatek.inc (172.21.101.183) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Tue, 17 May 2022 16:17:10 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Tue, 17 May 2022 16:17:10 +0800
Subject: Re: [PATCH v1] scsi: ufs-mediatek: introduce new UFS4.0 HS-G5 mode
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <jejb@linux.ibm.com>, <wsd_upstream@mediatek.com>,
        <linux-mediatek@lists.infradead.org>, <chun-hung.wu@mediatek.com>,
        <alice.chao@mediatek.com>, <cc.chou@mediatek.com>,
        <chaotian.jing@mediatek.com>, <jiajie.hao@mediatek.com>,
        <powen.kao@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>, <eddie.huang@mediatek.com>,
        <tun-yu.yu@mediatek.com>
References: <20220512135654.3656-1-peter.wang@mediatek.com>
 <yq1ee0srkc0.fsf@ca-mkp.ca.oracle.com>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <eb3b9979-2a45-8ebd-bd65-e463f8be4e81@mediatek.com>
Date:   Tue, 17 May 2022 16:17:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <yq1ee0srkc0.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

OK. Will change next version.

Thanks for review.


On 5/17/22 10:00 AM, Martin K. Petersen wrote:
> Peter,
>
>> @@ -4101,6 +4101,7 @@ static int ufshcd_uic_change_pwr_mode(struct ufs_hba *hba, u8 mode)
>>   out:
>>   	return ret;
>>   }
>> +EXPORT_SYMBOL(ufshcd_uic_change_pwr_mode);
>>   
>>   int ufshcd_link_recovery(struct ufs_hba *hba)
>>   {
> EXPORT_SYMBOL_GPL()?
>
