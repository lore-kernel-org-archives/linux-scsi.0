Return-Path: <SRS0=Rxtd=XL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_2
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2BBBC49ED7
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 06:30:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EBEF20890
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Sep 2019 06:30:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729610AbfIPGaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Sep 2019 02:30:01 -0400
Received: from mailgw01.mediatek.com ([210.61.82.183]:7503 "EHLO
        mailgw01.mediatek.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728040AbfIPGaA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Sep 2019 02:30:00 -0400
X-UUID: 7f74738b3fc0427f90bab4943fda15ab-20190916
X-UUID: 7f74738b3fc0427f90bab4943fda15ab-20190916
Received: from mtkcas07.mediatek.inc [(172.21.101.84)] by mailgw01.mediatek.com
        (envelope-from <stanley.chu@mediatek.com>)
        (Cellopoint E-mail Firewall v4.1.10 Build 0809 with TLS)
        with ESMTP id 1892138216; Mon, 16 Sep 2019 14:29:55 +0800
Received: from MTKCAS06.mediatek.inc (172.21.101.30) by
 mtkmbs02n2.mediatek.inc (172.21.101.101) with Microsoft SMTP Server (TLS) id
 15.0.1395.4; Mon, 16 Sep 2019 14:29:52 +0800
Received: from [172.21.77.33] (172.21.77.33) by MTKCAS06.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1395.4 via Frontend
 Transport; Mon, 16 Sep 2019 14:29:52 +0800
Message-ID: <1568615392.16730.17.camel@mtkswgap22>
Subject: Re: [PATCH v2 3/3] scsi: ufs-mediatek: enable auto suspend
 capability
From:   Stanley Chu <stanley.chu@mediatek.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     <linux-scsi@vger.kernel.org>, <martin.petersen@oracle.com>,
        <avri.altman@wdc.com>, <alim.akhtar@samsung.com>,
        <pedrom.sousa@synopsys.com>, <sthumma@codeaurora.org>,
        <jejb@linux.ibm.com>, <linux-mediatek@lists.infradead.org>,
        <linux-arm-kernel@lists.infradead.org>, <matthias.bgg@gmail.com>,
        <evgreen@chromium.org>, <beanhuo@micron.com>,
        <marc.w.gonzalez@free.fr>, <subhashj@codeaurora.org>,
        <vivek.gautam@codeaurora.org>, <kuohong.wang@mediatek.com>,
        <peter.wang@mediatek.com>, <chun-hung.wu@mediatek.com>,
        <andy.teng@mediatek.com>
Date:   Mon, 16 Sep 2019 14:29:52 +0800
In-Reply-To: <160452c7-c53c-155c-49a9-4365166032a8@acm.org>
References: <1568270135-32442-1-git-send-email-stanley.chu@mediatek.com>
         <1568270135-32442-4-git-send-email-stanley.chu@mediatek.com>
         <160452c7-c53c-155c-49a9-4365166032a8@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-TM-SNTS-SMTP: 75057D6A14387FD4D93A3473C52F51AE3FD1B009813949CF92BCA4F9F378EA592000:8
X-MTK:  N
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,


> > @@ -147,6 +152,8 @@ static int ufs_mtk_init(struct ufs_hba *hba)
> >  	if (err)
> >  		goto out_variant_clear;
> >  
> > +	ufs_mtk_set_caps(hba);
> > +
> >  	/*
> >  	 * ufshcd_vops_init() is invoked after
> >  	 * ufshcd_setup_clock(true) in ufshcd_hba_init() thus
> 
> Please inline the ufs_mtk_set_caps() function. Introducing single line
> functions like is done in this patch doesn't improve readability.
> 

OK! Will be fixed in next version.

Thanks,
Stanley


