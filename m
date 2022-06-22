Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 184F2C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jun 2022 15:47:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359476AbiFVPrU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jun 2022 11:47:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359452AbiFVPrS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jun 2022 11:47:18 -0400
Received: from smtpbg.qq.com (smtpbg139.qq.com [175.27.65.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BC573A5DF;
        Wed, 22 Jun 2022 08:47:12 -0700 (PDT)
X-QQ-mid: bizesmtp82t1655912818tj316vfu
Received: from ubuntu.localdomain ( [106.117.78.84])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Wed, 22 Jun 2022 23:46:51 +0800 (CST)
X-QQ-SSF: 01000000008000B0C000E00A0000000
X-QQ-FEAT: lC5HeAtE+ybpWJvPlMY4q+X7QecgsK1KuqPmyqv0LOZQcv9VGoNS9n96zZdZD
        QEKJJ2XnB00imctSCSEZ9Z438q0rgDVeTTXcMNqwAxyIw38UeIutPE+4mbmYKBbkTYbJPTb
        gKj066SldrajjKYMvN8+Zi03xM/7WywXDleNm4gUxfQ/gM1wOTtEG3sDXYPOgtHKmNyHW/i
        ryP+ZSQHy34i2+mcqkuUs8krONJCGc6td3h5w53JNCsGDNOhLw14DyALFvuipAQ3WCwpHHK
        F9VLMklTJfyDeeqZi1LHRZjMWJ4FKBc3ybIqiCvKhPzy098T/rmvxbS5/REDQ5+i7nxCFbA
        qZM+sAoXMKAw2RjDsFXUwemvjvWGdbqmMsMXwVH
X-QQ-GoodBg: 0
From:   Jiang Jian <jiangjian@cdjrlc.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     jiangjian@cdjrlc.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: aic94xx: fix typos in comments
Date:   Wed, 22 Jun 2022 23:46:49 +0800
Message-Id: <20220622154649.6979-1-jiangjian@cdjrlc.com>
X-Mailer: git-send-email 2.17.1
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Replace 'is' with 'it'

file: drivers/scsi/aic94xx/aic94xx_scb.c
line: 624

*  - if no device is connected to the LED, is is dimmed (off).

changed to:

*  - if no device is connected to the LED, it is dimmed (off).

Signed-off-by: Jiang Jian <jiangjian@cdjrlc.com>
---
 drivers/scsi/aic94xx/aic94xx_scb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_scb.c b/drivers/scsi/aic94xx/aic94xx_scb.c
index 68214a58b160..86cadb80bb02 100644
--- a/drivers/scsi/aic94xx/aic94xx_scb.c
+++ b/drivers/scsi/aic94xx/aic94xx_scb.c
@@ -621,7 +621,7 @@ int asd_init_post_escbs(struct asd_ha_struct *asd_ha)
  * A note on LEDs:
  *  - an LED blinks if there is IO though it,
  *  - if a device is connected to the LED, it is lit,
- *  - if no device is connected to the LED, is is dimmed (off).
+ *  - if no device is connected to the LED, it is dimmed (off).
  */
 static void control_phy_tasklet_complete(struct asd_ascb *ascb,
 					 struct done_list_struct *dl)
-- 
2.17.1

