From: Laurence Oberman <loberman@redhat.com>
Subject: [PATCH] Added notes to scsi-parameters.txt to show how to pass parameters on kernel line
Date: Thu, 19 Oct 2017 10:20:03 -0400
Message-ID: <1508422803-17361-1-git-send-email-loberman@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47104 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753938AbdJSOUG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Oct 2017 10:20:06 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id B56D07EA93
        for <linux-scsi@vger.kernel.org>; Thu, 19 Oct 2017 14:20:06 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, loberman@redhat.com

---
 Documentation/scsi/scsi-parameters.txt | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/scsi/scsi-parameters.txt b/Documentation/scsi/scsi-parameters.txt
index 8477655..5b87a11 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -116,3 +116,11 @@ parameters may be changed at runtime by the command
 
 	wd33c93=	[HW,SCSI]
 			See header of drivers/scsi/wd33c93.c.
+
+Additional notes on passing parameters on the command line:
+
+It's not intuitively obvious how to pass certain parameters on the boot line.
+For parameters such as scsi_dev_flags, you need to pass these to the scsi_mod as 
+the following example for the scsi_dev_flags. 
+
+On kernel line add scsi_mod.dev_flags=LIO-ORG:thin2:0x8000000
-- 
1.8.3.1
