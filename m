From: Rob Landley <rob@landley.net>
Subject: [PATCH 3/15] Update kerneldoc comments in drivers/scsi/constants.c
Date: Fri, 26 Oct 2007 23:09:35 -0500
Message-ID: <200710262309.35760.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:47478
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753993AbXJ0DJv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Oct 2007 23:09:51 -0400
Received: from landley.net (localhost [127.0.0.1])
	by grelber.thyrsus.com (Postfix) with ESMTP id 713AA73938
	for <linux-scsi@vger.kernel.org>; Fri, 26 Oct 2007 23:12:35 -0400 (EDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: Rob Landley <rob@landley.net>

Update kerneldoc comments in drivers/scsi/constants.c

Signed-off-by: Rob Landley <rob@landley.net>
---

 drivers/scsi/constants.c |    1 -
 1 file changed, 1 deletion(-)

diff -r a868e8217782 drivers/scsi/constants.c
--- a/drivers/scsi/constants.c	Mon Oct 22 19:40:02 2007 -0700
+++ b/drivers/scsi/constants.c	Fri Oct 26 22:44:42 2007 -0500
@@ -362,7 +362,6 @@ EXPORT_SYMBOL(scsi_print_command);
 EXPORT_SYMBOL(scsi_print_command);
 
 /**
- *
  *	scsi_print_status - print scsi status description
  *	@scsi_status: scsi status value
  *

-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
