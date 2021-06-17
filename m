Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2645AC48BE5
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 01:33:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 09B776112D
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Jun 2021 01:33:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232053AbhFQBfN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 21:35:13 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:54060 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231942AbhFQBfN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 21:35:13 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210617013305epoutp04180e439c6f0bd5c1f9b95669cdee5ace~JOpytpwn31891318913epoutp04C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Jun 2021 01:33:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210617013305epoutp04180e439c6f0bd5c1f9b95669cdee5ace~JOpytpwn31891318913epoutp04C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1623893585;
        bh=D1qpqMB+OkXfuoIE8lfCNhPZsTDS/KWRKBsTuRhnzk4=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=i28FkUl/aDW/UCLtvJrqynJLATyhM98s3OtUUf/QuTyASSRMHgoo+eQbIpzVTFD3W
         jan8vR2+WrfmuDB/0SXtdFUAjaoJzzAnv7aHYnpwJ3xNuK1DLoVTf9mIepYYgac9QP
         ofaq+c48DOE5jC1x7ze0YRg8fvGlMlg4Erbi5m58=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20210617013304epcas3p17a347b736bc80bc03e0350435c8944c2~JOpx7PZ6P1174411744epcas3p1O;
        Thu, 17 Jun 2021 01:33:04 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp4.localdomain
        (Postfix) with ESMTP id 4G54Lm2bBjz4x9QM; Thu, 17 Jun 2021 01:33:04 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: Re: [PATCH] scsi: ufs: Add indent for code alignment
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Joe Perches <joe@perches.com>,
        Keoseong Park <keosung.park@samsung.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "satyat@google.com" <satyat@google.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <e0950e65c5e7f8f0db132cfd22bdd24ee27c63e7.camel@perches.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <2038148563.21623893584364.JavaMail.epsvc@epcpadp4>
Date:   Thu, 17 Jun 2021 10:28:39 +0900
X-CMS-MailID: 20210617012839epcms2p16d271ab83109fd286939bbb48ebba30f
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30
References: <e0950e65c5e7f8f0db132cfd22bdd24ee27c63e7.camel@perches.com>
        <1891546521.01623299401994.JavaMail.epsvc@epcpadp3>
        <CGME20210610040731epcms2p7533bc62d13b82a0e86590f30ac4b6c30@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>On Thu, 2021-06-10 at 13:07 +0900, Keoseong Park wrote:
>> Add indentation to return statement.
>[]
>> diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>[]
>> @@ -903,7 +903,7 @@ static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
>>  	else
>>  		return false;
>>  #else
>> -return true;
>> +	return true;
>>  #endif
>>  }
>>  
>
>Perhaps a little refactoring instead:
>---
> drivers/scsi/ufs/ufshcd.h | 12 ++++--------
> 1 file changed, 4 insertions(+), 8 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>index c98d540ac044d..ed89839476b3b 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>@@ -894,15 +894,11 @@ static inline bool ufshcd_is_rpm_autosuspend_allowed(struct ufs_hba *hba)
> static inline bool ufshcd_is_intr_aggr_allowed(struct ufs_hba *hba)
> {
> /* DWC UFS Core has the Interrupt aggregation feature but is not detectable*/
>-#ifndef CONFIG_SCSI_UFS_DWC
>-	if ((hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>-	    !(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR))
>+	if (IS_ENABLED(CONFIG_SCSI_UFS_DWC))
> 		return true;
>-	else
>-		return false;
>-#else
>-return true;
>-#endif
>+
>+	return (hba->caps & UFSHCD_CAP_INTR_AGGR) &&
>+		!(hba->quirks & UFSHCD_QUIRK_BROKEN_INTR_AGGR);
> }
> 
> static inline bool ufshcd_can_aggressive_pc(struct ufs_hba *hba)
>

Hello Joe,
Thanks for your advice.
As you mentioned, refactoring looks good.
However, since the content does not match the title, can I submit a patch with a new title?

Best Regards,
Keoseong
