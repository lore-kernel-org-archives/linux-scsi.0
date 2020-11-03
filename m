Return-Path: <SRS0=0yur=EJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28DFAC388F2
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8F7122277
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Nov 2020 06:24:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726211AbgKCGYp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Nov 2020 01:24:45 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:13324 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgKCGYp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2020 01:24:45 -0500
IronPort-SDR: RY22A9yFMBxDCL13DZ2QGkyPOq5/zUUuGI25kf7/FNHgK+SeF4LJJeGVJIOabiWNZVRx+cHCVX
 8GM/qi6nShWXMmqfth5EgC3Fwo5BSHmvrCEqroLR6KIYeWdO6y+VwZxHSZaY6wzq64OtJe3gp1
 hGcXl+47FSeOi7IbKjds2CluTdf5+hVod4R4Qytun/Fm0TBeKtr1bRds42pfOiml+2KsBz0izM
 j5pXpfAxhokPiSDlHIGor4KNKXZkHHKBN3AOupR5di5ElFrFqTMmajw6rj11UkKXeyt0yuw5p6
 Uos=
X-IronPort-AV: E=Sophos;i="5.77,447,1596524400"; 
   d="scan'208";a="29256946"
Received: from unknown (HELO ironmsg01-sd.qualcomm.com) ([10.53.140.141])
  by labrats.qualcomm.com with ESMTP; 02 Nov 2020 22:24:45 -0800
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg01-sd.qualcomm.com with ESMTP; 02 Nov 2020 22:24:44 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 76C13217C9; Mon,  2 Nov 2020 22:24:44 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v1 0/2] Two minor fixes for UFS driver
Date:   Mon,  2 Nov 2020 22:24:38 -0800
Message-Id: <1604384682-15837-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series contains two minor fixes, one for clk gating and one
for PMC/UIC cmd completion timeout.

Can Guo (2):
  scsi: ufs: Fix unbalanced scsi_block_reqs_cnt caused by ufshcd_hold()
  scsi: ufs: Try to save power mode change and UIC cmd completion
    timeout

 drivers/scsi/ufs/ufshcd.c | 32 +++++++++++++++++++++++++++-----
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 29 insertions(+), 5 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

