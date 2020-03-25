Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42A44C2D0E7
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:29:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2A96020777
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 18:29:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727485AbgCYS3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 14:29:17 -0400
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:27404 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727129AbgCYS3R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 25 Mar 2020 14:29:17 -0400
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 25 Mar 2020 11:29:16 -0700
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg02-sd.qualcomm.com with ESMTP; 25 Mar 2020 11:29:16 -0700
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 3C34A208CE; Wed, 25 Mar 2020 11:29:16 -0700 (PDT)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     Avri.Altman@wdc.com, cang@codeaurora.org,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH v2 0/3] UFS Clock Scaling fixes and enhancements
Date:   Wed, 25 Mar 2020 11:28:59 -0700
Message-Id: <cover.1585160616.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Enhancements to clock-scaling parameters.
Few bug fixes to clock-scaling.

Changes since v1:
- Addressed comments of v1

Asutosh Das (3):
  scsi: ufshcd: Update the set frequency to devfreq
  scsi: ufshcd: Let vendor override devfreq parameters
  scsi: ufs-qcom: Override devfreq parameters

 drivers/scsi/ufs/ufs-qcom.c | 25 +++++++++++++++++++++++++
 drivers/scsi/ufs/ufshcd.c   | 32 ++++++++++++++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h   | 12 ++++++++++++
 3 files changed, 67 insertions(+), 2 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

