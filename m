Return-Path: <SRS0=ycLx=5L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C76C43331
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 09:37:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2DE3F20714
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Mar 2020 09:37:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgCZJha (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Mar 2020 05:37:30 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:18272 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgCZJha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Mar 2020 05:37:30 -0400
IronPort-SDR: rY74TxQTEZtxZHqvID1oYtmpjUsUqvFmwSSesIqxtj39dNfmhA4D04EMD74CXWMJQn6iJoJ/v9
 fNuGoJ15xyGld+5uk1UyfuHzYX8MsM6OUhpXiQLQVug4Kg2Lb/vVPLdiqvPBOL1GaZfGQgvmjJ
 29+yZTwuyr0pP8hprfsvq9IgTbNDSJl2q31+E3K2JP9c2p0utku/fISOvTkKoMjmiVSCQGM9V2
 FCqRsPfGs9UFwpvQzEIFVoQMIG3jFJx40PgnmeSOx3Wb/mW4Oib6WUnyu9IIAi8AIX6HDgUovd
 6Jg=
X-IronPort-AV: E=Sophos;i="5.72,307,1580803200"; 
   d="scan'208";a="28616315"
Received: from unknown (HELO ironmsg-SD-alpha.qualcomm.com) ([10.53.140.30])
  by labrats.qualcomm.com with ESMTP; 26 Mar 2020 02:25:55 -0700
Received: from pacamara-linux.qualcomm.com ([192.168.140.135])
  by ironmsg-SD-alpha.qualcomm.com with ESMTP; 26 Mar 2020 02:25:54 -0700
Received: by pacamara-linux.qualcomm.com (Postfix, from userid 359480)
        id 4907B3AA6; Thu, 26 Mar 2020 02:25:54 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v6 0/2] UFS driver general fixes bundle 2
Date:   Thu, 26 Mar 2020 02:25:39 -0700
Message-Id: <1585214742-5466-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This bundle includes 2 general fixes for UFS driver.

Changes since v5:
- Fixed a compilation error

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

 drivers/scsi/ufs/ufshcd.c | 91 ++++++++++++++++++++++++++++++-----------------
 drivers/scsi/ufs/ufshcd.h | 11 ------
 2 files changed, 59 insertions(+), 43 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

