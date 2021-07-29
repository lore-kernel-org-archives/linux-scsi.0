Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19378C4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F03156101C
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 00:58:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbhG2A6I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 20:58:08 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:28330 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233017AbhG2A6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jul 2021 20:58:08 -0400
Received: from epcas3p4.samsung.com (unknown [182.195.41.22])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20210729005804epoutp03c477c8f670be76cc8ad335108d82ba15~WHRNualKE0148501485epoutp03d
        for <linux-scsi@vger.kernel.org>; Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20210729005804epoutp03c477c8f670be76cc8ad335108d82ba15~WHRNualKE0148501485epoutp03d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1627520284;
        bh=YKj/GyUBBlEmfwiy02zZ5bInnkvpsqU6Km1bRuNWeUA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=QeLOWJtuthPoJRVpzYD7ii70PQK0PTb6ExwqEm1up51/GTIAKYfyI/ddVIrLD9xMK
         ZPKOR2n6McMMqRoRbsZD6SnI1I+cgnAKsJIzX3lLBw3S3O0akz/C5a5/4cldCF+eGE
         3ox37zRY/A+4JSxLgfbKgGPBjS5I8rBsS7OTgrng=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas3p4.samsung.com (KnoxPortal) with ESMTP id
        20210729005804epcas3p4aea169b9f2e9dd0edf112cb116dde71f~WHRNTNEWY0911709117epcas3p4F;
        Thu, 29 Jul 2021 00:58:04 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp3.localdomain
        (Postfix) with ESMTP id 4GZsb012Brz4x9QC; Thu, 29 Jul 2021 00:58:04 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v3 04/18] scsi: ufs: Rename the second
 ufshcd_probe_hba() argument
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Can Guo <cang@codeaurora.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Daejun Park <daejun7.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20210722033439.26550-5-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1226204845.121627520284129.JavaMail.epsvc@epcpadp4>
Date:   Thu, 29 Jul 2021 09:56:57 +0900
X-CMS-MailID: 20210729005657epcms2p66805a8fd925daba9b52a29ceb31a6f30
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210722033520epcas2p31c6f801eda7f100491c85e3f9c7d6600
References: <20210722033439.26550-5-bvanassche@acm.org>
        <20210722033439.26550-1-bvanassche@acm.org>
        <CGME20210722033520epcas2p31c6f801eda7f100491c85e3f9c7d6600@epcms2p6>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>Rename the second argument of ufshcd_probe_hba() such that the name of
>that argument reflects its purpose instead of how the function is called.
>See also commit 1b9e21412f72 ("scsi: ufs: Split ufshcd_probe_hba() based
>on its called flow").

Reviewed-by: Daejun Park <daejun7.park@samsung.com>

Thanks,
Daejun
