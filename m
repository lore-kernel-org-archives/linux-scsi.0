From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: [PATCH v3 6/8] MAINTAINERS: Update megaraid maintainers list
Date: Fri, 21 Oct 2016 06:33:34 -0700
Message-ID: <1477056816-7058-7-git-send-email-kashyap.desai@broadcom.com>
References: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f169.google.com ([209.85.192.169]:35460 "EHLO
        mail-pf0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933649AbcJUNe1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2016 09:34:27 -0400
Received: by mail-pf0-f169.google.com with SMTP id s8so57269288pfj.2
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2016 06:34:27 -0700 (PDT)
In-Reply-To: <1477056816-7058-1-git-send-email-kashyap.desai@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, sumit.saxena@broadcom.com

Update MEGARAID drivers maintainers list.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Reviewed-by: Hannes Reinecke <hare@suse.com>
---
 MAINTAINERS | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index f0ee7a6..8b9117f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7612,12 +7612,12 @@ S:	Maintained
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
2.4.11

