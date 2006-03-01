From: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>
Subject: [PATCH 19/22] lpfc 8.1.2: Fixed module parameter descriptions.
Date: Tue, 28 Feb 2006 19:25:35 -0500
Message-ID: <20060301002535.GA15570@shrimp.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from shrimp.ma.emulex.com ([138.239.78.42]:62912 "EHLO
	shrimp.ma.emulex.com") by vger.kernel.org with ESMTP
	id S964867AbWCAAZh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Feb 2006 19:25:37 -0500
Received: from shrimp.ma.emulex.com (localhost.localdomain [127.0.0.1])
	by shrimp.ma.emulex.com (8.13.4/8.13.4) with ESMTP id k210PZIV015576
	for <linux-scsi@vger.kernel.org>; Tue, 28 Feb 2006 19:25:35 -0500
Received: (from jamesw@localhost)
	by shrimp.ma.emulex.com (8.13.4/8.13.4/Submit) id k210PZrW015575
	for linux-scsi@vger.kernel.org; Tue, 28 Feb 2006 19:25:35 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fixed module parameter descriptions.

Signed-off-by: Jamie Wellnitz <Jamie.Wellnitz@emulex.com>

--- a/drivers/scsi/lpfc/lpfc_attr.c
+++ b/drivers/scsi/lpfc/lpfc_attr.c
@@ -664,10 +664,10 @@ LPFC_ATTR_R(ack0, 0, 0, 1, "Enable ACK0 
 # is 0. Default value of cr_count is 1. The cr_count feature is disabled if
 # cr_delay is set to 0.
 */
-LPFC_ATTR_RW(cr_delay, 0, 0, 63, "A count of milliseconds after which an"
+LPFC_ATTR_RW(cr_delay, 0, 0, 63, "A count of milliseconds after which an "
 		"interrupt response is generated");
 
-LPFC_ATTR_RW(cr_count, 1, 1, 255, "A count of I/O completions after which an"
+LPFC_ATTR_RW(cr_count, 1, 1, 255, "A count of I/O completions after which an "
 		"interrupt response is generated");
 
 /*
@@ -683,7 +683,7 @@ LPFC_ATTR_RW(fdmi_on, 0, 0, 2, "Enable F
 # Specifies the maximum number of ELS cmds we can have outstanding (for
 # discovery). Value range is [1,64]. Default value = 32.
 */
-LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands"
+LPFC_ATTR(discovery_threads, 32, 1, 64, "Maximum number of ELS commands "
 		 "during discovery");
 
 /*
