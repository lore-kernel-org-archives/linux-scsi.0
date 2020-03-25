Return-Path: <SRS0=rA/a=5K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5332FC18E5B
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 09:26:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 19172206F6
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Mar 2020 09:26:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgCYJ0R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Mar 2020 05:26:17 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:22954 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgCYJ0R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Mar 2020 05:26:17 -0400
IronPort-SDR: bnMxPc0DxxSdycpPY27iDcEmZGI49uup4exm8hRQj9J+OES+1naHrqaN4PjBYO2Jdmy+jY6dtA
 yaQSzXc8yOuo2xbm29NPTidXwkSUBw/R4MFPecIA4hxCJpUyqqQ1Jn8LU7g1C4XCQwiJNJRWSo
 3C/wsP/My2H0zkvfxn6Zz+QV1ejM0YdGZ9fELEkT5mV5tAu1PxYsatNknouOhCV/tT6kdl4JpL
 98lsc4t+PJNI6E9VTZxZofkmrnHLs3O+aO7+zel3JnzCZnttnpjcvyZgZjHaq1z580CeyVoeSN
 XK4=
X-IronPort-AV: E=Sophos;i="5.72,303,1580803200"; 
   d="scan'208";a="28615550"
Received: from unknown (HELO ironmsg03-sd.qualcomm.com) ([10.53.140.143])
  by labrats.qualcomm.com with ESMTP; 25 Mar 2020 02:24:45 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg03-sd.qualcomm.com with ESMTP; 25 Mar 2020 02:24:44 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 762703A9C; Wed, 25 Mar 2020 02:24:44 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v5 0/2] UFS driver general fixes bundle 2
Date:   Wed, 25 Mar 2020 02:23:37 -0700
Message-Id: <1585128220-26128-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 2 general fixes for UFS driver.

Changes since v4:
- Incoperated comments from Avri.
- Added trace back to func ufshcd_scale_clks()
- Removed scale_up_gear goto
- Added "Fixes" tag to commit messages

Changes since v3:
- Removed trivial spaces in comments

Changes since v2:
- Rebased on 5.7/scsi-queue and fixed minor conflicts

Changes since v1:
- Fixed minor typo


Can Guo (1):
  scsi: ufs: Do not rely on prefetched data

Subhash Jadavani (1):
  scsi: ufs: Clean up ufshcd_scale_clks() and clock scaling error out
    path

 drivers/scsi/ufs/ufshcd.c | 94 ++++++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h | 11 ------
 2 files changed, 61 insertions(+), 44 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

