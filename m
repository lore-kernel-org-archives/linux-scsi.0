Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3439C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:37:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DC8460BD3
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhDAGhI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 02:37:08 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:44064 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233143AbhDAGgl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 02:36:41 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 9DD73980149;
        Thu,  1 Apr 2021 14:36:38 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] scsi: bfa: Remove unnecessary struct declaration
Date:   Thu,  1 Apr 2021 14:35:34 +0800
Message-Id: <20210401063535.992487-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGUIdGkgaGUgYGkhLVkpNSkxJTkNCQkJLSUxVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBA6NTo4ED8KODRNTAgJAT4o
        DBJPC0JVSlVKTUpMSU5DQkJCSEtPVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKQ09NNwY+
X-HM-Tid: 0a788c25eca3d992kuws9dd73980149
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

struct bfa_fcs_s is declared twice. One is declared
at 50th line. Remove the duplicate.
struct bfa_fcs_fabric_s is defined at 175th line.
Remove unnecessary declaration.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/scsi/bfa/bfa_fcs.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs.h b/drivers/scsi/bfa/bfa_fcs.h
index 3e117fed95c9..c1baf5cd0d3e 100644
--- a/drivers/scsi/bfa/bfa_fcs.h
+++ b/drivers/scsi/bfa/bfa_fcs.h
@@ -217,9 +217,6 @@ struct bfa_vf_event_s {
 	u32        undefined;
 };
 
-struct bfa_fcs_s;
-struct bfa_fcs_fabric_s;
-
 /*
  * @todo : need to move to a global config file.
  * Maximum Rports supported per port (physical/logical).
-- 
2.25.1

