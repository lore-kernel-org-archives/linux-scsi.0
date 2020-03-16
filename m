Return-Path: <SRS0=cHy8=5B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F97CC0044D
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:33:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF35820663
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Mar 2020 06:33:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729516AbgCPGdO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Mar 2020 02:33:14 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:5828 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgCPGdO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Mar 2020 02:33:14 -0400
IronPort-SDR: gGEg/Ohcrf/X1ngwT/VB8oU+A16R57ipe7fYVoqiTgiGPLrZ3Cl52Z9lDPUAT1uaAD9pRCqL35
 gC+Cyt5gnBG1vPrl8YbZTA8Pp1jB+VYLlX5sBnrQ5FvuY9ogRVxEEcNcjAw8OBlc1BtUWc5UCm
 chYZOGRM3bR9GzPKlEX2CctrgVUf4Ro/Eb3D3QQIvQ6Yu4/hzB7uPeqlgmAZB4aQsutXZ04nrl
 04krVqf69zdkbbROR/3G7SaSDQRAyy4CQxohtEauY6FJqU2y6S+MfMSwujq4Pya6jxrS9sK7we
 vXQ=
X-IronPort-AV: E=Sophos;i="5.70,559,1574150400"; 
   d="scan'208";a="28594802"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 15 Mar 2020 23:20:58 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg04-sd.qualcomm.com with ESMTP; 15 Mar 2020 23:20:57 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 4BD4D3A61; Sun, 15 Mar 2020 23:20:57 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v3 0/2] UFS driver general fixes bundle 2
Date:   Sun, 15 Mar 2020 23:20:50 -0700
Message-Id: <1584339655-20337-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 2 general fixes for UFS driver.

Changes since v2:
- Rebased on 5.7/scsi-queue and fixed minor conflicts

Changes since v1:
- Fixed minor typo

Can Guo (1):
  scsi: ufs: Do not rely on prefetched data

Subhash Jadavani (1):
  scsi: ufs: Clean up ufshcd_scale_clks() and clock scaling error out
    path

 drivers/scsi/ufs/ufshcd.c | 100 +++++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h |  11 -----
 2 files changed, 64 insertions(+), 47 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

