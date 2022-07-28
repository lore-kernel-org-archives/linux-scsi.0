Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5535C04A68
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jul 2022 19:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231858AbiG1TAb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jul 2022 15:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbiG1TA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jul 2022 15:00:29 -0400
Received: from alexa-out-sd-01.qualcomm.com (alexa-out-sd-01.qualcomm.com [199.106.114.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C232ABC02;
        Thu, 28 Jul 2022 12:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=quicinc.com; i=@quicinc.com; q=dns/txt; s=qcdkim;
  t=1659034828; x=1690570828;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=QCH1ItzV0KMBiEEScypOp5iCtuClkJoas7APqtx/Xdc=;
  b=bzQKWjA/MkyJlCsZhOl7ZkXBihv0R0Sf5yUgFQUqBAJCOC7KpganGoh8
   COc9gU3XEd9iGG5lAuL8l9eIvv0AY1ou9bZWLVJIWId8eDXDL/xv+TTmA
   nJLNKnWirEajvwkDylhJCfI4QwdB2bRhZ+3iodOx71FGhhMbc1tjZXEi2
   E=;
Received: from unknown (HELO ironmsg02-sd.qualcomm.com) ([10.53.140.142])
  by alexa-out-sd-01.qualcomm.com with ESMTP; 28 Jul 2022 12:00:28 -0700
X-QCInternal: smtphost
Received: from unknown (HELO nasanex01a.na.qualcomm.com) ([10.52.223.231])
  by ironmsg02-sd.qualcomm.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 Jul 2022 12:00:28 -0700
Received: from hu-cchinnad-hyd.qualcomm.com (10.80.80.8) by
 nasanex01a.na.qualcomm.com (10.52.223.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.22; Thu, 28 Jul 2022 12:00:25 -0700
From:   Chetan C R <quic_cchinnad@quicinc.com>
To:     <bvanassche@acm.org>
CC:     <jejb@linux.ibm.com>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        Chetan C R <quic_cchinnad@quicinc.com>
Subject: [PATCH V3] scsi: ufs: Get boot device storage type from command line
Date:   Fri, 29 Jul 2022 00:30:13 +0530
Message-ID: <1659034814-3473-1-git-send-email-quic_cchinnad@quicinc.com>
X-Mailer: git-send-email 2.7.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.80.8]
X-ClientProxiedBy: nasanex01b.na.qualcomm.com (10.46.141.250) To
 nasanex01a.na.qualcomm.com (10.52.223.231)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1->v2:
- Made UFS_QCOM_CMDLINE as default 'Y' to get __setup() addressing review comments from Bart
v2->v3
- Made ufs-cmdline to build as core driver obj-y

Thanks for your response!

Chetan C R (1):
  scsi: ufs: Get boot device storage type from command line

 drivers/ufs/host/Makefile      |  1 +
 drivers/ufs/host/ufs-cmdline.c | 54 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 55 insertions(+)
 create mode 100644 drivers/ufs/host/ufs-cmdline.c

-- 
2.7.4

