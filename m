From: Sumit Saxena <sumit.saxena@broadcom.com>
Subject: [PATCH v2 5/7] MAINTAINERS: Update megaraid maintainers list
Date: Thu, 20 Oct 2016 02:05:03 -0700
Message-ID: <1476954305-576-6-git-send-email-sumit.saxena@broadcom.com>
References: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f175.google.com ([209.85.192.175]:33898 "EHLO
        mail-pf0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757493AbcJTJF3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Oct 2016 05:05:29 -0400
Received: by mail-pf0-f175.google.com with SMTP id r16so32859699pfg.1
        for <linux-scsi@vger.kernel.org>; Thu, 20 Oct 2016 02:05:29 -0700 (PDT)
In-Reply-To: <1476954305-576-1-git-send-email-sumit.saxena@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, Sumit Saxena <sumit.saxena@broadcom.com>

Update MEGARAID drivers maintainers list.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4c1f3f9..05c0624 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7823,12 +7823,12 @@ S:	Maintained
 F:	drivers/net/wireless/mediatek/mt7601u/
 
 MEGARAID SCSI/SAS DRIVERS
-M:	Kashyap Desai <kashyap.desai@avagotech.com>
-M:	Sumit Saxena <sumit.saxena@avagotech.com>
-M:	Uday Lingala <uday.lingala@avagotech.com>
-L:	megaraidlinux.pdl@avagotech.com
+M:	Kashyap Desai <kashyap.desai@broadcom.com>
+M:	Sumit Saxena <sumit.saxena@broadcom.com>
+M:	Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
+L:	megaraidlinux.pdl@broadcom.com
 L:	linux-scsi@vger.kernel.org
-W:	http://www.lsi.com
+W:	http://www.avagotech.com/support/
 S:	Maintained
 F:	Documentation/scsi/megaraid.txt
 F:	drivers/scsi/megaraid.*
-- 
1.8.3.1

