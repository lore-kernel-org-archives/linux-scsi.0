From: Laurence Oberman <loberman@redhat.com>
Subject: Patch: add to Documentation/scsi for scsi_dev_flags and command
 line passing
Date: Wed, 18 Oct 2017 13:13:09 -0400
Message-ID: <1508346789.13599.2.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:55280 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750853AbdJRRNL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2017 13:13:11 -0400
Received: by mail-qt0-f196.google.com with SMTP id z19so11146016qtg.11
        for <linux-scsi@vger.kernel.org>; Wed, 18 Oct 2017 10:13:10 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Tired of forgetting about this so documented it for others so they also
don't spend unnecessary time figuring this out.

Signed-off-by: Laurence Oberman <loberman@redhat.com>

diff --git a/Documentation/scsi/scsi-parameters.txt
b/Documentation/scsi/scsi-parameters.txt
index 8477655..c9e9ce8 100644
--- a/Documentation/scsi/scsi-parameters.txt
+++ b/Documentation/scsi/scsi-parameters.txt
@@ -116,3 +116,9 @@ parameters may be changed at runtime by the command
 
 	wd33c93=	[HW,SCSI]
 			See header of drivers/scsi/wd33c93.c.
+
+Additional notes on passing parameters on the command line.
+Its not intuitively obvious how to pass certain parameters on the boot
line.
+For parameters such as scsi_dev_flags, you need to pass to the
scsi_mod as follows
+scsi_mod.dev_flags=LIO-ORG:thin2:0x80000000
+
-- 
1.8.3.1
