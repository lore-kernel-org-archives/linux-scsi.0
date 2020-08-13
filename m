Return-Path: <SRS0=CV/f=BX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5CE1C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:25:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A55E420829
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Aug 2020 02:25:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DGM41s1V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726667AbgHMCZH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 22:25:07 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:20083 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726656AbgHMCZH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 22:25:07 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20200813022504epoutp0417d1a4b1579e327c01ffd4d61d9bbb12~qsrQMYcu-2316923169epoutp041
        for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2020 02:25:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20200813022504epoutp0417d1a4b1579e327c01ffd4d61d9bbb12~qsrQMYcu-2316923169epoutp041
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1597285504;
        bh=6FW9BUn7hT5lceD/kAcb3ERCZXuG0FNm5Vrm1zFkDyQ=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=DGM41s1VNdnTmYzW6lEqmJPqIdQSgDKdMjD9ZeizKfwsPb3npNQxeoUjk9ahIpAO3
         ICxIFzgOJMKiVvDNh5yaS91uKny6aBlyt1MTyVu6EzZ3+xIVsdEl5StkAwsUTl+te9
         4z6bEotNUNbp6obR6RgOkE24wkAJutZoLKBAgJhE=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p1.samsung.com
        (KnoxPortal) with ESMTP id
        20200813022503epcas1p10f24f43a65a4d4551fb9875850d6c0e7~qsrPzhOjM2360423604epcas1p1G;
        Thu, 13 Aug 2020 02:25:03 +0000 (GMT)
Mime-Version: 1.0
Subject: Re: [PATCH v8 1/4] scsi: ufs: Add UFS feature related parameter
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <adb044b2-67e0-b451-332c-37789ded99f9@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1431530910.81597285503798.JavaMail.epsvc@epcpadp1>
Date:   Thu, 13 Aug 2020 11:16:25 +0900
X-CMS-MailID: 20200813021625epcms2p6a4b743bce7ef961ab06d20615293e2f4
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d
References: <adb044b2-67e0-b451-332c-37789ded99f9@acm.org>
        <231786897.01596704281715.JavaMail.epsvc@epcpadp2>
        <231786897.01596705001840.JavaMail.epsvc@epcpadp1>
        <CGME20200806073257epcms2p61564ed62e02fc42fc3c2b18fa92a038d@epcms2p6>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

> On 2020-08-06 02:02, Daejun Park wrote:
> > @@ -537,6 +548,7 @@ struct ufs_dev_info {
> >      u8 *model;
> >      u16 wspecversion;
> >      u32 clk_gating_wait_us;
> > +    u8 b_ufs_feature_sup;
> >      u32 d_ext_ufs_feature_sup;
> >      u8 b_wb_buffer_type;
> >      u32 d_wb_alloc_units;
> > 
> 
> Hmm ... shouldn't this variable be introduced in the patch that introduces
> the code that sets and uses this variable?

OK, I will move this variable to 2/4 patch.

> How about making it clear in the patch subject that this patch adds protocol
> constants related to HPB?

The subject will be changed :
"Add UFS feature related parameter -> Adds constants related to HPB"
 
> Otherwise this patch looks good to me.
> 
> Bart.

Thanks,

Daejun
