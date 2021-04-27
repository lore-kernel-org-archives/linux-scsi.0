Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C89EC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 261646100C
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Apr 2021 07:40:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234973AbhD0Hk7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Apr 2021 03:40:59 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:31478 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235000AbhD0Hky (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Apr 2021 03:40:54 -0400
Received: from epcas3p3.samsung.com (unknown [182.195.41.21])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20210427074009epoutp046c5fb0df507d8911f7678266a9bc6ec4~5pwuj3cHJ2802928029epoutp04T
        for <linux-scsi@vger.kernel.org>; Tue, 27 Apr 2021 07:40:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20210427074009epoutp046c5fb0df507d8911f7678266a9bc6ec4~5pwuj3cHJ2802928029epoutp04T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1619509209;
        bh=PrsfVE4deZ/xb+RnXu0vDm3K/Nkxr6m3k4bSEBKWYBE=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=YICT8Q6K7SyYiCrHki1+253HIy39S6j02daOrhe1RMD+AmtVb2VGHjDHUmgHmvhU3
         ufyiCEfVJznDaNCJp5eJiGnZCTl8RFPRYkdph4zAQ9YjL8IoTrgmXjXk6k/bVmAAku
         oNUBE3vPmDP/PRGiqG43tRCoq4VMJPDR2kCSpslI=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20210427074008epcas3p267f57edbd4cd25a7ccdfbfeaffec0294~5pwuGZvLJ0697306973epcas3p2h;
        Tue, 27 Apr 2021 07:40:08 +0000 (GMT)
Received: from epcpadp3 (unknown [182.195.40.17]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4FTtvr6Y7kz4x9Pv; Tue, 27 Apr 2021 07:40:08 +0000
        (GMT)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: Fix a typo in ufs-sysfs.c
Reply-To: keosung.park@samsung.com
Sender: Keoseong Park <keosung.park@samsung.com>
From:   Keoseong Park <keosung.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "huyue2@yulong.com" <huyue2@yulong.com>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC:     Daejun Park <daejun7.park@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1381713434.61619509208911.JavaMail.epsvc@epcpadp3>
Date:   Tue, 27 Apr 2021 16:38:42 +0900
X-CMS-MailID: 20210427073842epcms2p1efa82e558171ad06c9398ea7c364e7dc
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20210427073842epcms2p1efa82e558171ad06c9398ea7c364e7dc
References: <CGME20210427073842epcms2p1efa82e558171ad06c9398ea7c364e7dc@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Change 'ufschd' to 'ufshcd'.

Fix the following typo:

 ufschd_uic_link_state_to_string() -> ufshcd_uic_link_state_to_string()
 ufschd_ufs_dev_pwr_mode_to_string() -> ufshcd_ufs_dev_pwr_mode_to_string()

Signed-off-by: Keoseong Park <keosung.park@samsung.com>
---
 drivers/scsi/ufs/ufs-sysfs.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-sysfs.c b/drivers/scsi/ufs/ufs-sysfs.c
index d7c3cff9662f..5d0e98a05ada 100644
--- a/drivers/scsi/ufs/ufs-sysfs.c
+++ b/drivers/scsi/ufs/ufs-sysfs.c
@@ -9,7 +9,7 @@
 #include "ufs.h"
 #include "ufs-sysfs.h"
 
-static const char *ufschd_uic_link_state_to_string(
+static const char *ufshcd_uic_link_state_to_string(
 			enum uic_link_state state)
 {
 	switch (state) {
@@ -21,7 +21,7 @@ static const char *ufschd_uic_link_state_to_string(
 	}
 }
 
-static const char *ufschd_ufs_dev_pwr_mode_to_string(
+static const char *ufshcd_ufs_dev_pwr_mode_to_string(
 			enum ufs_dev_pwr_mode state)
 {
 	switch (state) {
@@ -81,7 +81,7 @@ static ssize_t rpm_target_dev_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
+	return sysfs_emit(buf, "%s\n", ufshcd_ufs_dev_pwr_mode_to_string(
 			ufs_pm_lvl_states[hba->rpm_lvl].dev_state));
 }
 
@@ -90,7 +90,7 @@ static ssize_t rpm_target_link_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
+	return sysfs_emit(buf, "%s\n", ufshcd_uic_link_state_to_string(
 			ufs_pm_lvl_states[hba->rpm_lvl].link_state));
 }
 
@@ -113,7 +113,7 @@ static ssize_t spm_target_dev_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%s\n", ufschd_ufs_dev_pwr_mode_to_string(
+	return sysfs_emit(buf, "%s\n", ufshcd_ufs_dev_pwr_mode_to_string(
 				ufs_pm_lvl_states[hba->spm_lvl].dev_state));
 }
 
@@ -122,7 +122,7 @@ static ssize_t spm_target_link_state_show(struct device *dev,
 {
 	struct ufs_hba *hba = dev_get_drvdata(dev);
 
-	return sysfs_emit(buf, "%s\n", ufschd_uic_link_state_to_string(
+	return sysfs_emit(buf, "%s\n", ufshcd_uic_link_state_to_string(
 				ufs_pm_lvl_states[hba->spm_lvl].link_state));
 }
 
-- 
2.17.1


