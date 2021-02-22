Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27C74C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:22:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C686E60C3E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 08:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230008AbhBVIWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 03:22:45 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:51779 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhBVIWl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2021 03:22:41 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210222082159epoutp042f9590f6db5b514c776c7fb77b2cbb2c~mBC_mPLKa0046600466epoutp04I
        for <linux-scsi@vger.kernel.org>; Mon, 22 Feb 2021 08:21:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210222082159epoutp042f9590f6db5b514c776c7fb77b2cbb2c~mBC_mPLKa0046600466epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1613982119;
        bh=wf9owq+FMxy6TzPevBvv9+v5GHiUn8Wbll+MzEXLgc0=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=mqOzP26yrkdaIp2SV105nTlGLUeAD+rmBtvwa2e5NYe9TX+l1sUC71cDtBdmg4e4Z
         IoxlgVS7+nWFxQgrkG7dOhaaq8HIJ06nrdUaLbA15P/vONoHLx60vPgl/D9sXLudd7
         r8jsEaOOcZUk9Q5o0m0ay0XWo8ThdEiS4owhaTnM=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210222082157epcas2p34ad06ed581d38fa4e06d2c7b6d97be63~mBC8w67Nq0563305633epcas2p3y;
        Mon, 22 Feb 2021 08:21:57 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4DkZsb6vYwz4x9QG; Mon, 22 Feb
        2021 08:21:55 +0000 (GMT)
X-AuditID: b6c32a48-50fff7000000cd1f-08-603369a364e3
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        55.9C.52511.3A963306; Mon, 22 Feb 2021 17:21:55 +0900 (KST)
Mime-Version: 1.0
Subject: RE: RE: [PATCH v21 4/4] scsi: ufs: Add HPB 2.0 support
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Avri Altman <Avri.Altman@wdc.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "huobean@gmail.com" <huobean@gmail.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        JinHwan Park <jh.i.park@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <DM6PR04MB6575B0CAAAEFACBC719257F5FC839@DM6PR04MB6575.namprd04.prod.outlook.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210222082155epcms2p4bf924773e8497cf75d72ab9eef1a0d1c@epcms2p4>
Date:   Mon, 22 Feb 2021 17:21:55 +0900
X-CMS-MailID: 20210222082155epcms2p4bf924773e8497cf75d72ab9eef1a0d1c
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA52Te0xbVRzHPb2lr8i8sBYOmGi9hNcCpS295cBWNxddrjIWjWNLnAg35YYS
        oZC2EEAT6+Q9XjO6IY/qOhmPobWEQik4FhgPydBtMB0v6RSMSHDMOSMs22xpcYt/+t83n/P9
        ne/v9zs5PMx/gBvMy9QaGJ2WziI4AnbPcGRc9NnM2DTpioNETlMPB31dOs5FKxvXOWh47ncu
        OrW+gaE/LOd80MpQJOpwHkUfnLVwUNOkkYWqa20c9PP8HS4y3+hhodoHZWw05WjioBM/2Dmo
        dewBC811C1CLbQagitOdbGQ+08/eJ6KmphOpqZpqFtXXsMCl6swXATXY3Mmlir8ZZFO3l2fZ
        VE13B6DudD1DlV08wXpV8IYR7KF1ak1mPiNmtOqc9ExthopIPnwgGhFiTY7eoCKOyZBcIosn
        JYp4iTwuJUEmlcpJQqylsxkVURDtrSbEOnWuy21g9AYdo2ZcSLdPb6AzGImeztbnaTMk6pxs
        QpxPZ+W56oiY5/doGDqd0YnTloBmoaIot5hf0FLWyjGCy5xKwOdBXAEv20/5uLU/bgdwuTKv
        EvB4vrgfvG/f6cY78b3QsliOeSwEtFxt4Hq4BM7e7ARuzcGj4OnxRRcX8IT4PQxeXXPfKeBh
        eAsGzy8bMU+YL6wvW2Z79NOwt9W2Vc3HU+DAx06uh0fAv89Ve/0iOHN+jbutb41+CjxaCEt+
        nPR6/KBzo9/Lg+Bo/zrLo9+DtvlN4G4C4lUADvfN+ngOYuD35Va2Z8okaLPGuzEbD4V/Otq8
        vb0Im+tubi0Iw5+FvWtNmNuO4ZHQ4ohxS4iHwEuz7O2pjNZ73P9qDN8By4fv/8vtpiVvZ2Hw
        yw0Lqw6ENDzadMNjWQ2Psj4DWAcIYHL12RmMXp6rePyZu8DWD9hF2UHj2rpkCLB4YAhAHkYI
        fTkL8jR/33S6sIjR5aTq8rIY/RAock15EgsWqXNcX0hrSJUppXIlGauIjSUV5P/GpFyplMaT
        iFTKERHoq5M6U/3xDNrAvM0wuYxuO5zF4wcbWXtXg4GiJ2LtOCj2m8NLm8iF4/tNwUFHzIdu
        3Go5KDPRKuvJblPSWN+Tw/rQ57rF7aMbyfQvb4aZlno6CjQJm2Cg6/XdsaqwrGXLC4MJxZpv
        D39VM3v7XVqJR708MZ7/sFHxoSg5qCnKNpM2knetNNxZPFbb7rBeWP91/dol2WCJOCm8NGni
        ldSKj+6GNE4XVrQd2dErDA+5Mi2qaeZHHJt8KbEwIPD911afSJz43G+RKXmr+Qv86G+ipxJX
        rzMpVVVlQtZmVNZCnOphY6h5fIRUGaj9ZHc/Y3Vc6ReMvfOdMKKSHbB7dcRY/1OQ+cLdkk8O
        1PMDD7WfyRbNt+UfzDT8RbD1Glq2C9Pp6X8AJOON9c8EAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210218090627epcms2p639c216ccebed773120121b1d53641d94
References: <DM6PR04MB6575B0CAAAEFACBC719257F5FC839@DM6PR04MB6575.namprd04.prod.outlook.com>
        <20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p6>
        <20210218090853epcms2p8ccac0b5611dec22afd04ecc06e74498e@epcms2p8>
        <CGME20210218090627epcms2p639c216ccebed773120121b1d53641d94@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> >         kmem_cache_destroy(hpb->map_req_cache);
> > @@ -1670,7 +2109,7 @@ void ufshpb_init_hpb_lu(struct ufs_hba *hba, struct
> > scsi_device *sdev)
> >         if (ret)
> >                 goto out;
> > 
> > -       hpb = ufshpb_alloc_hpb_lu(hba, lun, &hba->ufshpb_dev,
> > +       hpb = ufshpb_alloc_hpb_lu(hba, sdev, &hba->ufshpb_dev,
> >                                   &hpb_lu_info);
> >         if (!hpb)
> >                 goto out;
> In HPB2.0 device control mode, the host is expected to send HPB-WRITE-BUFFER 0x3
> To informs that all HPB Regions are inactive (expect for pinned regions).
> Maybe a good place to do so is here, or in ufshpb_hpb_lu_prepared after you kicked the map work for pinned regions.

Done

> Either way, If you decide to do so, I would appreciate if you could align to the framework I proposed in
> (scsi: ufshpb: Region inactivation in host mode).
> This way you would have a wrapper unmap_all that would call ufshpb_issue_umap_req with buffer id 0x3,
> And I would have a wrapper unmap_single that would call it with buffer id 0x1.

I will do this way on the next patch.

Thanks,
Daejun
