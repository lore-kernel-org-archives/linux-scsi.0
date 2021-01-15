Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54DA7C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 01:37:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F3A3F23A7C
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 01:37:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbhAOBhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 20:37:08 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:22087 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbhAOBhH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 20:37:07 -0500
IronPort-SDR: fAjd6maB/IsCBt4MdzpDsfkHlw5hTrQxuOJab0Ka6HPbi/pCF4x3+My+IQEL/54A1/GOyqgRzY
 xXMuuOabMYJ9jxRkejSI8oOKuh386WP8pLCUuUyjpW16I7nGTDkX8EB3VRnIXwatEt/L1dHX9+
 MOScnD4vc4scoy9pg+aIBX2E+9iYNtO59tp5qJsBnpMaEfNSN4c9acpf84Zo8G9O/L7zJel0QI
 WbvYogjP6XoLYgamLCCGfcIsMicc7yJeZREbCx9Y6R+M/IeoXOrZuhMHFybX3QIpxJgePtweFh
 Go8=
X-IronPort-AV: E=Sophos;i="5.79,347,1602572400"; 
   d="scan'208";a="47663408"
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by labrats.qualcomm.com with ESMTP; 14 Jan 2021 17:36:28 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg05-sd.qualcomm.com with ESMTP; 14 Jan 2021 17:36:27 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 2C72B218C5; Thu, 14 Jan 2021 17:36:27 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v1 0/2] Two minor changes related with error handling
Date:   Thu, 14 Jan 2021 17:36:17 -0800
Message-Id: <1610674580-20811-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The 1st change is a complementary change for error handling.
The 2nd change disables IRQ in host reset path to avoid possible NoC issues.

Can Guo (1):
  scsi: ufs: Minor adjustments to error handling

Nitin Rawat (1):
  scsi: ufs-qcom: Disable interrupt in reset path

 drivers/scsi/ufs/ufs-qcom.c | 10 ++++++++++
 drivers/scsi/ufs/ufshcd.c   | 14 +++++++++++---
 2 files changed, 21 insertions(+), 3 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

