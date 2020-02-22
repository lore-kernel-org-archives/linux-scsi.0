Return-Path: <SRS0=uhQV=4K=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B976AC35669
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:47:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 979F420722
	for <linux-scsi@archiver.kernel.org>; Sat, 22 Feb 2020 00:47:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727229AbgBVArd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Feb 2020 19:47:33 -0500
Received: from alexa-out-sd-01.qualcomm.com ([199.106.114.38]:28014 "EHLO
        alexa-out-sd-01.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726328AbgBVArc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Feb 2020 19:47:32 -0500
Received: from unknown (HELO ironmsg05-sd.qualcomm.com) ([10.53.140.145])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 21 Feb 2020 16:47:32 -0800
Received: from asutoshd-linux1.qualcomm.com ([10.46.160.39])
  by ironmsg05-sd.qualcomm.com with ESMTP; 21 Feb 2020 16:47:32 -0800
Received: by asutoshd-linux1.qualcomm.com (Postfix, from userid 92687)
        id 10F3F216F4; Fri, 21 Feb 2020 16:47:31 -0800 (PST)
From:   Asutosh Das <asutoshd@codeaurora.org>
To:     subhashj@codeaurora.org, cang@codeaurora.org,
        rnayak@codeaurora.org, vinholikatti@gmail.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     Asutosh Das <asutoshd@codeaurora.org>,
        linux-arm-msm@vger.kernel.org
Subject: [<RFC PATCH v1> 0/2] Write Booster Implementation 
Date:   Fri, 21 Feb 2020 16:47:19 -0800
Message-Id: <cover.1582330473.git.asutoshd@codeaurora.org>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
Message-ID: <20200222004719.whlDyLNdNZiIcA5kyU3mGOPqRVa49cUbDBmkjUKdTp4@z>

Write Booster has been added to UFS-3.1 specification-Section-13.4.17
This is a RFC implementation of the same.


Asutosh Das (2):
  scsi: ufs: add write booster feature support
  ufs-qcom: scsi: configure write booster type

 drivers/scsi/ufs/ufs-qcom.c  |   7 ++
 drivers/scsi/ufs/ufs-sysfs.c |  41 ++++++-
 drivers/scsi/ufs/ufs.h       |  61 ++++++++-
 drivers/scsi/ufs/ufshcd.c    | 286 ++++++++++++++++++++++++++++++++++++++++++-
 drivers/scsi/ufs/ufshcd.h    |   9 ++
 5 files changed, 397 insertions(+), 7 deletions(-)

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

