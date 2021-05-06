Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36292C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 05:00:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F0C44613BA
	for <linux-scsi@archiver.kernel.org>; Thu,  6 May 2021 05:00:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232400AbhEFFB0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 May 2021 01:01:26 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:62079 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbhEFFB0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 May 2021 01:01:26 -0400
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210506050026epoutp022c384b51612f9d93e36b6a019bd2d6fe~8YY2is_3q3262632626epoutp02J
        for <linux-scsi@vger.kernel.org>; Thu,  6 May 2021 05:00:26 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210506050026epoutp022c384b51612f9d93e36b6a019bd2d6fe~8YY2is_3q3262632626epoutp02J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1620277226;
        bh=F3J654zQy5fErEDnpL9ybNsFSQ0UrbeXbnhu/38BMgU=;
        h=Subject:Reply-To:From:To:In-Reply-To:Date:References:From;
        b=VZdjXbllnQHpowCkMQBtbIVWDusRhPTK7Ptl+yRzIwn+ZgBsXBDOcWSUBrJgTpNHN
         Zdy6vMNmYDXqgeLdKp1ZFodup/Km82l7SxVVlvLJMABHmBWvVV7U++RYInBhLrQUAB
         fypLcjtSjHpQ/qPGlgf5NpIu9KIY5uw+LBQhGlF0=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20210506050022epcas2p201f765940001bba08542751ae94dda04~8YYy6Xetg1870418704epcas2p2F;
        Thu,  6 May 2021 05:00:22 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.186]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4FbLxH3DRMz4x9Q1; Thu,  6 May
        2021 05:00:19 +0000 (GMT)
X-AuditID: b6c32a48-4e5ff700000025f5-a0-609377e2e437
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        33.F2.09717.2E773906; Thu,  6 May 2021 14:00:18 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH v5 0/2] Introduce hba performance monitoring sysfs nodes
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "nguyenb@codeaurora.org" <nguyenb@codeaurora.org>,
        "hongwus@codeaurora.org" <hongwus@codeaurora.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210506050017epcms2p5d1ba7ffa4173d1ee6d9c5ac784df4a03@epcms2p5>
Date:   Thu, 06 May 2021 14:00:17 +0900
X-CMS-MailID: 20210506050017epcms2p5d1ba7ffa4173d1ee6d9c5ac784df4a03
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrPKsWRmVeSWpSXmKPExsWy7bCmue6j8skJBv/65Sz2tp1gt/i0fhmr
        xctDmhann71jt9ixXcSi+/oONouPXbMZHdg9tu3exupxua+XyaNvyypGj8+b5AJYonJsMlIT
        U1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4D2KymUJeaUAoUC
        EouLlfTtbIryS0tSFTLyi0tslVILUnIKDA0L9IoTc4tL89L1kvNzrQwNDIxMgSoTcjL+7/rM
        VrCJueJk7xnmBsZnTF2MnBwSAiYS3Q1fWLsYuTiEBHYwSly9cIqli5GDg1dAUOLvDmGQGmEB
        H4mri+8yg9hCAkoS6y/OYoeI60nceriGEcRmE9CRmH7iPjvIHBGBQ0wS/179YoVYwCsxo/0p
        C4QtLbF9+VawBk4BF4ndP7ZA1WhI/FjWywxhi0rcXP2WHcZ+f2w+I4QtItF67yxUjaDEg5+7
        oeKSEsd2f4B6pl5i651fjCBHSAj0MEoc3nkLaoG+xLWOjWBH8Ar4Spy9eRBsEIuAqsSKVSDf
        cADVuEjcOJUDEmYWkJfY/nYOM0iYWUBTYv0ufYgKZYkjt1hgvmrY+Jsdnc0swCfRcfgvXHzH
        vCdQl6lJrPu5nglijIzErXmMExiVZiHCeRaStbMQ1i5gZF7FKJZaUJybnlpsVGCCHLWbGMEp
        UctjB+Pstx/0DjEycTAeYpTgYFYS4S1Y258gxJuSWFmVWpQfX1Sak1p8iNEU6N+JzFKiyfnA
        pJxXEm9oamRmZmBpamFqZmShJM77M7UuQUggPbEkNTs1tSC1CKaPiYNTqoGJp7Tz8vdZczJm
        sQf/Mrngv6BWz6j4VZ5ya+21mhXRckbqhuGHfry6U/Bf8/LbtdytwiK5+jeuehRNd0j+/3Hz
        5X8bvnfVC32NWGjjcDTdPa1K8NmDKL6odzbn7tUW2+5dsHxHr+INN+3PQhp75D4lxu66fLzF
        1yRqq6KtkIVCNjNfn2fOLc6bBjwCtzrqjQvTZob88lj/dXWvWl2J2oEpav3RFv3Zl0p1X1r4
        rVT81h+qMeHl0aInCcxz9nh+vHemif+2r9qGv0WPOnpcWE69W8UUsurNsy9vPoXzzhCR0Yss
        n7LRvCCF8S7T9rOebq5rT75gnp+qvCyg7OfBzBBmoYL4gKNdofGzFPovzFBiKc5INNRiLipO
        BACVspTQEgQAAA==
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210422022910epcas2p1c28bc11ee4118559d967e83bd8434c7f
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
        <CGME20210422022910epcas2p1c28bc11ee4118559d967e83bd8434c7f@epcms2p5>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Can Guo,

>Add a new sysfs group which has nodes to monitor data/request transfer
>performance. This sysfs group has nodes showing total sectors/requests
>transferred, total busy time spent and max/min/avg/sum latencies. This
>group can be enhanced later to show more UFS driver layer performance
>data during runtime.

This series looks good to me.
Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
