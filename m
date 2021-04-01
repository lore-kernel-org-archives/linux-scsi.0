Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5903EC433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5C96105A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 07:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233445AbhDAHjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 03:39:20 -0400
Received: from labrats.qualcomm.com ([199.106.110.90]:49605 "EHLO
        labrats.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233240AbhDAHjN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 03:39:13 -0400
IronPort-SDR: TuonfCjVWSHQWs6NhUTDBBxI/ajqPPiXFD4+jQcpqPYKP0fP81AWqIg/8U2oBM8hHA1gBlLNz8
 ysrHz+zfEGDWlaTqcvHvhTwd+CObiKngpkbasAnGv8o2eZf79AhiHZ+WEQRQPktemsl5OFWE16
 9TfNddxrh8amnK5MAf0LhAzJf1Ru4FY01PswiAXRxTEFm+4fw6cEeO/Ab2826Px2dP3xBL96wl
 09TdNUDNnrXGTs/md0gM2SzyJWGs+p4ORI2TJWdMe9+1stB9TIKw6JQBNTHqVx34Aa7e837lB8
 rq0=
X-IronPort-AV: E=Sophos;i="5.81,296,1610438400"; 
   d="scan'208";a="29736675"
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by labrats.qualcomm.com with ESMTP; 01 Apr 2021 00:39:12 -0700
X-QCInternal: smtphost
Received: from stor-presley.qualcomm.com ([192.168.140.85])
  by ironmsg02-sd.qualcomm.com with ESMTP; 01 Apr 2021 00:39:10 -0700
Received: by stor-presley.qualcomm.com (Postfix, from userid 359480)
        id DF96C210A9; Thu,  1 Apr 2021 00:39:10 -0700 (PDT)
From:   Can Guo <cang@codeaurora.org>
To:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, cang@codeaurora.org
Subject: [PATCH v5 0/2] Two fixes for task management request implementation
Date:   Thu,  1 Apr 2021 00:39:07 -0700
Message-Id: <1617262750-4864-1-git-send-email-cang@codeaurora.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These fixes are based on Jaegeuk's change - https://git.kernel.org/mkp/scsi/c/eeb1b55b6e25

Change since v4:
- Incorporated Daejun's comments

Change since v3:
- Deleted the 2nd change
- Incorporated Bart's comments

Change since v2:
- Split one change into 3 changes

Change since v1:
- Typo fixed


Can Guo (2):
  scsi: ufs: Fix task management request completion timeout
  scsi: ufs: Fix wrong Task Tag used in task management request UPIUs

 drivers/scsi/ufs/ufshcd.c | 31 ++++++++++++++-----------------
 1 file changed, 14 insertions(+), 17 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

