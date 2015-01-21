From: Asaf Vertz <asaf.vertz@tandemg.com>
Subject: [PATCH] scsi: 3w-9xxx: fix format string warnings
Date: Wed, 21 Jan 2015 14:44:43 +0200
Message-ID: <20150121124443.GA18019@ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f180.google.com ([74.125.82.180]:61996 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751878AbbAUMor (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Jan 2015 07:44:47 -0500
Received: by mail-we0-f180.google.com with SMTP id m14so17678347wev.11
        for <linux-scsi@vger.kernel.org>; Wed, 21 Jan 2015 04:44:46 -0800 (PST)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linuxraid@lsi.com
Cc: JBottomley@parallels.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Fixed the following warnings (reported by cppcheck):
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 2)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 3)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 4)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 5)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 6)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 7)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 8)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 9)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 10)
requires 'int' but the argument type is 'unsigned int'.
[drivers/scsi/3w-9xxx.c:166]: (warning) %d in format string (no. 11)
requires 'int' but the argument type is 'unsigned int'.

Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
---
 drivers/scsi/3w-9xxx.c |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/scsi/3w-9xxx.c b/drivers/scsi/3w-9xxx.c
index 7600639..123eba5 100644
--- a/drivers/scsi/3w-9xxx.c
+++ b/drivers/scsi/3w-9xxx.c
@@ -164,16 +164,16 @@ static ssize_t twa_show_stats(struct device *dev,
 
 	spin_lock_irqsave(tw_dev->host->host_lock, flags);
 	len = snprintf(buf, PAGE_SIZE, "3w-9xxx Driver version: %s\n"
-		       "Current commands posted:   %4d\n"
-		       "Max commands posted:       %4d\n"
-		       "Current pending commands:  %4d\n"
-		       "Max pending commands:      %4d\n"
-		       "Last sgl length:           %4d\n"
-		       "Max sgl length:            %4d\n"
-		       "Last sector count:         %4d\n"
-		       "Max sector count:          %4d\n"
-		       "SCSI Host Resets:          %4d\n"
-		       "AEN's:                     %4d\n", 
+		       "Current commands posted:   %4u\n"
+		       "Max commands posted:       %4u\n"
+		       "Current pending commands:  %4u\n"
+		       "Max pending commands:      %4u\n"
+		       "Last sgl length:           %4u\n"
+		       "Max sgl length:            %4u\n"
+		       "Last sector count:         %4u\n"
+		       "Max sector count:          %4u\n"
+		       "SCSI Host Resets:          %4u\n"
+		       "AEN's:                     %4u\n",
 		       TW_DRIVER_VERSION,
 		       tw_dev->posted_request_count,
 		       tw_dev->max_posted_request_count,
-- 
1.7.0.4

