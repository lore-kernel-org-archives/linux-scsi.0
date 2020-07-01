Return-Path: <SRS0=yW27=AM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 297A7C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:10:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0992020780
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Jul 2020 00:10:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EyiLEzs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726051AbgGAAKF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 20:10:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:64785 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgGAAKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 20:10:04 -0400
Received: from epcas1p4.samsung.com (unknown [182.195.41.48])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200701001002epoutp02f2928c99c5bd7be1f0a5e231ace81df9~deGFAlK000811408114epoutp02W
        for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2020 00:10:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200701001002epoutp02f2928c99c5bd7be1f0a5e231ace81df9~deGFAlK000811408114epoutp02W
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1593562202;
        bh=QWZJSb/2p+9cthTdrVYq6eDkK91lgMsygQOaAVOoG+s=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=EyiLEzs3KKFxtL7pF/rBLT70RK112+vS5SBCs7i3G0ErLsNWRinv2yqHrEI09w6RV
         8G5oiAdWS5NyQ00VgCP1kLbGOCXu9Df/f9TEQHrse7r1Xl59tqI0a0KfXgPXcv5kbm
         6HJhmTLXcQdplabnvnUpRUzTQlT9u4ztEG55bzx4=
Received: from epcpadp1 (unknown [182.195.40.11]) by epcas1p2.samsung.com
        (KnoxPortal) with ESMTP id
        20200701001001epcas1p2ba55774cedc604a1bab26c99f1afa406~deGEZzUS60336103361epcas1p2c;
        Wed,  1 Jul 2020 00:10:01 +0000 (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4 3/5] scsi: ufs: Introduce HPB module
Reply-To: daejun7.park@samsung.com
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
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
In-Reply-To: <SN6PR04MB4640A27B0DCB321B165D59F0FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1087081975.11593562201594.JavaMail.epsvc@epcpadp1>
Date:   Wed, 01 Jul 2020 09:07:57 +0900
X-CMS-MailID: 20200701000757epcms2p38c0c86b2fcfc414e75a5bcaafa3222cb
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20200629064323epcms2p787baba58a416fef7fdd3927f8da701da
References: <SN6PR04MB4640A27B0DCB321B165D59F0FC6F0@SN6PR04MB4640.namprd04.prod.outlook.com>
        <963815509.21593413582881.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413402991.JavaMail.epsvc@epcpadp1>
        <231786897.01593413281727.JavaMail.epsvc@epcpadp2>
        <1239183618.61593413882377.JavaMail.epsvc@epcpadp2>
        <CGME20200629064323epcms2p787baba58a416fef7fdd3927f8da701da@epcms2p3>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Avri,

> +static int ufshpb_get_dev_info(struct ufs_hba *hba,
> > +                              struct ufshpb_dev_info *hpb_dev_info,
> > +                              u8 *desc_buf)
> > +{
> > +       int ret;
> > +       int version;
> > +       u8 hpb_mode;
> Maybe before doing anything, first verify that all descriptors are in the proper size?

Before reading descriptor, ufshcd_map_desc_id_to_length() may check descriptor size.
So I deleted size checking codes.

static int ufshpb_read_desc(struct ufs_hba *hba, u8 desc_id, u8 desc_index,    
                          u8 selector, u8 *desc_buf)                           
{                                                                              
        int err = 0;                                                           
        int size;                                                              
                                                                               
  ->    ufshcd_map_desc_id_to_length(hba, desc_id, &size);                     
                                                                               
        pm_runtime_get_sync(hba->dev);                                         
                                                                               
        err = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,  
                                            desc_id, desc_index,               
                                            selector,                          
                                            desc_buf, &size);  


> > +#define UFSHPB_WRITE_BUFFER_ID                 0x02
> Should be 0x01 for HPB1.0

OK.

Thanks,
Daejun
