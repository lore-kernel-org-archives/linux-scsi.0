Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA274C4361B
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:59:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7598323B84
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Dec 2020 06:59:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728261AbgLIG7D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Dec 2020 01:59:03 -0500
Received: from labrats.qualcomm.com ([199.106.110.90]:5506 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728190AbgLIG7D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Dec 2020 01:59:03 -0500
IronPort-SDR: oTnczU2Fn0iCNZNVWd+C0rViozIFuxRD40siB0lL/BQA07LdkzqevSVXQak3YASoIJYb6uIpcf
 /h9a4jIuuHkTTVcDofrv3j3RX/Jbp7SR7RM6VS+4AmsDmyUC1H6Gu2XLmCRVie07fQJUT8tvuL
 zZdarz18ZzLg48m4yMuvDUewFRPiMnb/wZShUIicGK2R34ew82m+jZ5A7P3bwITD+G4/tyrIQp
 GQe8pavluxhEVnLSffnSJb7kDY5j7pnEP4i7+Lc4DXGT16Eew62vOfDRfH5AyCFMbfUzv6R5wE
 fpg=
X-IronPort-AV: E=Sophos;i="5.78,404,1599548400"; 
   d="scan'208";a="47568892"
Received: from unknown (HELO ironmsg04-sd.qualcomm.com) ([10.53.140.144])
  by labrats.qualcomm.com with ESMTP; 08 Dec 2020 22:58:23 -0800
X-QCInternal: smtphost
Received: from wsp769891wss.qualcomm.com (HELO stor-presley.qualcomm.com) ([192.168.140.85])
  by ironmsg04-sd.qualcomm.com with ESMTP; 08 Dec 2020 22:58:22 -0800
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id 839BF212AC; Tue,  8 Dec 2020 22:58:22 -0800 (PST)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com, cang@codeaurora.org
Subject: [PATCH v1 0/2] Two changes related with UFS clock scaling
Date:   Tue,  8 Dec 2020 22:58:18 -0800
Message-Id: <1607497100-27570-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series is made based on 5.11/scsi-fixes branch.
The 1st change allows contexts to prevent clock scaling from being invoked through sysfs nodes like clkscale_enable.
The 2nd change is just a minor code cleanup.

Can Guo (2):
  scsi: ufs: Protect some contexts from unexpected clock scaling
  scsi: ufs: Clean up some lines from ufshcd_hba_exit()

 drivers/scsi/ufs/ufshcd.c | 91 +++++++++++++++++++++++++++--------------------
 drivers/scsi/ufs/ufshcd.h |  2 ++
 2 files changed, 54 insertions(+), 39 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

