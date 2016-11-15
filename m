From: Satish Kharat <satishkh@cisco.com>
Subject: [PATCH 1/1] [fnic, snic] Updating maintainers list for Cisco FNI and SNIC drivers
Date: Tue, 15 Nov 2016 12:39:29 -0800
Message-ID: <1479242369-3358-1-git-send-email-satishkh@cisco.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcdn-iport-4.cisco.com ([173.37.86.75]:1048 "EHLO
        rcdn-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752456AbcKOUtU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 15:49:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: satishkh@cisco.com, linux-scsi@vger.kernel.org, sebaddel@cisco.com

Signed-off-by: Satish Kharat <satishkh@cisco.com>
Signed-off-by: Sesidhar Baddela <sebaddel@cisco.com>
---
 MAINTAINERS | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b3a7774..11fdf45 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3149,15 +3149,15 @@ S:	Supported
 F:	drivers/clocksource
 
 CISCO FCOE HBA DRIVER
-M:	Hiral Patel <hiralpat@cisco.com>
-M:	Suma Ramars <sramars@cisco.com>
-M:	Brian Uchino <buchino@cisco.com>
+M:	Satish Kharat <satishkh@cisco.com>
+M:	Sesidhar Baddela <sebaddel@cisco.com>
+M:	Karan Tilak Kumar <kartilak@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	drivers/scsi/fnic/
 
 CISCO SCSI HBA DRIVER
-M:	Narsimhulu Musini <nmusini@cisco.com>
+M:	Karan Tilak Kumar <kartilak@cisco.com>
 M:	Sesidhar Baddela <sebaddel@cisco.com>
 L:	linux-scsi@vger.kernel.org
 S:	Supported
-- 
2.5.5

