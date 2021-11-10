Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 411C7C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2803F61106
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Nov 2021 14:40:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232265AbhKJOmy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 Nov 2021 09:42:54 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:59247 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232257AbhKJOmx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Nov 2021 09:42:53 -0500
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20211110144004epoutp036b7cf1702db17aeda013d73f999c12df~2NkmuICd40699206992epoutp03a
        for <linux-scsi@vger.kernel.org>; Wed, 10 Nov 2021 14:40:04 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20211110144004epoutp036b7cf1702db17aeda013d73f999c12df~2NkmuICd40699206992epoutp03a
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1636555204;
        bh=Bbx8/yZMDl8n81zbuICa1aVYnHiG+IrDi2ucjUvPebA=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=gFzJ9vvUhm2zaIHG7TRxtJzM+ePlgr7mM5D4vOzYnAaSQf6xAIR7QqcCcgz5OdZ4K
         8+anPKISPqp7nwWaALxiGo2OA6khuNH4gJ5xvNwE+8JzZWiCtQQjNLtqlptnsBWYUj
         wKRH3LW2mWtTQR3HA1NSFXC30YFfPEnRjGrWy7sk=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p1.samsung.com (KnoxPortal) with ESMTP id
        20211110144001epcas3p1ace910dd304a3414d290052a44ebb37b~2NkkBEIMF2215822158epcas3p1F;
        Wed, 10 Nov 2021 14:40:01 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4Hq6vP53YPz4x9Py; Wed, 10 Nov 2021 14:40:01 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH 01/11] scsi: ufs: Rename a function argument
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Yue Hu <huyue2@yulong.com>,
        Peter Wang <peter.wang@mediatek.com>,
        CHANHO PARK <chanho61.park@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Keoseong Park <keosung.park@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20211110004440.3389311-2-bvanassche@acm.org>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01636555201689.JavaMail.epsvc@epcpadp3>
Date:   Wed, 10 Nov 2021 18:48:59 +0900
X-CMS-MailID: 20211110094859epcms2p45c9708f216c3965bd227c8854781ff6d
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20211110004503epcas2p420544000401f38525f70bac1528623ee
References: <20211110004440.3389311-2-bvanassche@acm.org>
        <20211110004440.3389311-1-bvanassche@acm.org>
        <CGME20211110004503epcas2p420544000401f38525f70bac1528623ee@epcms2p4>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

>The new name makes it clear what the meaning of the function argument is.
>
>Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Keoseong Park <keosung.park@samsung.com>

Best Regards,
Keoseong Park

>---
> drivers/scsi/ufs/ufs-exynos.c | 4 ++--
> drivers/scsi/ufs/ufshcd.h     | 3 ++-
> 2 files changed, 4 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/scsi/ufs/ufs-exynos.c b/drivers/scsi/ufs/ufs-exynos.c
>index cd26bc82462e..474a4a064a68 100644
>--- a/drivers/scsi/ufs/ufs-exynos.c
>+++ b/drivers/scsi/ufs/ufs-exynos.c
>@@ -853,14 +853,14 @@ static int exynos_ufs_post_pwr_mode(struct ufs_hba *hba,
> }
> 
> static void exynos_ufs_specify_nexus_t_xfer_req(struct ufs_hba *hba,
>-						int tag, bool op)
>+						int tag, bool is_scsi_cmd)
> {
> 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> 	u32 type;
> 
> 	type =  hci_readl(ufs, HCI_UTRL_NEXUS_TYPE);
> 
>-	if (op)
>+	if (is_scsi_cmd)
> 		hci_writel(ufs, type | (1 << tag), HCI_UTRL_NEXUS_TYPE);
> 	else
> 		hci_writel(ufs, type & ~(1 << tag), HCI_UTRL_NEXUS_TYPE);
>diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>index 4ceb3c7e65b4..a911ad72de7a 100644
>--- a/drivers/scsi/ufs/ufshcd.h
>+++ b/drivers/scsi/ufs/ufshcd.h
>@@ -338,7 +338,8 @@ struct ufs_hba_variant_ops {
> 					enum ufs_notify_change_status status,
> 					struct ufs_pa_layer_attr *,
> 					struct ufs_pa_layer_attr *);
>-	void	(*setup_xfer_req)(struct ufs_hba *, int, bool);
>+	void	(*setup_xfer_req)(struct ufs_hba *hba, int tag,
>+				  bool is_scsi_cmd);
> 	void	(*setup_task_mgmt)(struct ufs_hba *, int, u8);
> 	void    (*hibern8_notify)(struct ufs_hba *, enum uic_cmd_dme,
> 					enum ufs_notify_change_status);
>
