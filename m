From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH update 4/4] scsi: update comment in scsi_host.h
Date: Sun, 13 Nov 2005 17:31:42 +0100 (CET)
Message-ID: <200511131634.jADGXvwQ000696@einhorn.in-berlin.de>
Mime-Version: 1.0
Content-Type: TEXT/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:3033 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S964930AbVKMQeJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Nov 2005 11:34:09 -0500
Received: from s5r6.in-berlin.de ([83.221.230.151])
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id jADGXvwQ000696
	for <linux-scsi@vger.kernel.org>; Sun, 13 Nov 2005 17:34:04 +0100
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

scsi_host.h: update comment on struct scsi_host_template.proc_name

Applies on top of patch "add further comments to struct scsi_host_template".
Depends on patches "remove usage of proc_name from scsi_host_alloc" and
"make proc_name sysfs attribute conditional".

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 include/scsi/scsi_host.h |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

patch update: correct statement when proc_name is required

--- linux-2.6.14-git3/include/scsi/scsi_host.h.bak	2005-11-13 16:24:58.000000000 +0100
+++ linux-2.6.14-git3/include/scsi/scsi_host.h	2005-11-13 16:56:47.000000000 +0100
@@ -310,7 +310,7 @@ struct scsi_host_template {
 	 * Name of proc directory. Also content of proc_name attribute of
 	 * the host's sysfs class device.
 	 *
-	 * Status: REQUIRED
+	 * Status: OBSOLETE	(REQUIRED if CONFIG_SCSI_PROC_FS is set)
 	 */
 	char *proc_name;
 


