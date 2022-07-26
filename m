Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4471BC43334
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Jul 2022 08:41:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238712AbiGZIlC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Jul 2022 04:41:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238708AbiGZIks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jul 2022 04:40:48 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0BDF22BFA
        for <linux-scsi@vger.kernel.org>; Tue, 26 Jul 2022 01:40:46 -0700 (PDT)
X-UUID: 4cc403199e3249c993edbe70a990f3ed-20220726
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.8,REQID:794ba584-945b-4c67-8eaf-d21556172c12,OB:0,LO
        B:0,IP:0,URL:5,TC:0,Content:2,EDM:0,RT:0,SF:22,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:29
X-CID-INFO: VERSION:1.1.8,REQID:794ba584-945b-4c67-8eaf-d21556172c12,OB:0,LOB:
        0,IP:0,URL:5,TC:0,Content:2,EDM:0,RT:0,SF:22,FILE:0,RULE:Release_Ham,ACTIO
        N:release,TS:29
X-CID-META: VersionHash:0f94e32,CLOUDID:d1fc85b3-06d2-48ef-b2dd-540836705165,C
        OID:IGNORED,Recheck:0,SF:28|100|17|19|48|101,TC:nil,Content:4,EDM:-3,IP:ni
        l,URL:1,File:nil,QS:nil,BEC:nil,COL:0
X-UUID: 4cc403199e3249c993edbe70a990f3ed-20220726
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw02.mediatek.com
        (envelope-from <peter.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 546816278; Tue, 26 Jul 2022 16:40:41 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.186) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Tue, 26 Jul 2022 16:40:40 +0800
Received: from [172.21.84.99] (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.15 via Frontend
 Transport; Tue, 26 Jul 2022 16:40:40 +0800
Subject: Re: [PATCH v1] ufs: core: change comment message to popular format
To:     Finn Thain <fthain@linux-m68k.org>,
        Bart Van Assche <bvanassche@acm.org>
CC:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
References: <20220725131558.13219-1-peter.wang@mediatek.com>
 <e962c613-7bdc-99f3-4273-b91beec614ee@acm.org>
 <f396dec0-67c2-30f-5be5-c99ecdb985db@linux-m68k.org>
From:   Peter Wang <peter.wang@mediatek.com>
Message-ID: <9e23c3dd-6907-3e6a-0dd0-ad26b9e517bb@mediatek.com>
Date:   Tue, 26 Jul 2022 16:40:40 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <f396dec0-67c2-30f-5be5-c99ecdb985db@linux-m68k.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 7/26/22 8:50 AM, Finn Thain wrote:
> On Mon, 25 Jul 2022, Bart Van Assche wrote:
>
>> On 7/25/22 06:15, peter.wang@mediatek.com wrote:
>>> From: Peter Wang <peter.wang@mediatek.com>
>>>
>>> Some editor cannot display ‘0’ ‘1’ in correct format.
>>> Change it to '0' '1' for most editor can display.
>> As far as I know checkpatch accepts non-ASCII UTF-8 characters. Using
>> this encoding is essential to spell non-English names correctly in
>> source files.
> The only foreign language that's relevant in the context of this
> particular comment is C. Writing '0' to indicate a char value would be
> fine but this is not a char value.
>
> Quoted and unquoted zeros are used inconsistently in this comment, though
> the patch does not address this unfortunately.
>
>> I don't think it's feasible nor desirable to eliminate all non-ASCII
>> UTF-8 from kernel source code files.
> That's neither here nor there -- I don't think it's feasible or desirable
> to eliminate all bugs from the kernel source code files. One man's bug is
> another man's feature e.g. bloat, choice of programming language,
> interpretation of license terms.
>
>> Maybe this means that it's time to switch to another editor?
>>
> It's not hard to find more tooling that is impacted by misplaced unicode.
> The security vulnerabilities stemming from the use of Unicode in source
> files are telling.
>
> Unicode doesn't help here so it shouldn't have been used here IMO.

Hi Finn,

Thank you for supplementary information.

Thanks.
Peter



