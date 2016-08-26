From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 15/17] smartpqi: update maintainers
Date: Fri, 26 Aug 2016 11:45:36 -0500
Message-ID: <147222993662.31214.1739657681215763725.stgit@brunhilda>
References: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0080.outbound.protection.outlook.com ([104.47.40.80]:36569
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753004AbcHZRB5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 13:01:57 -0400
In-Reply-To: <147222977996.31214.8588187948847476082.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, Viswas.G@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Kevin.Barnett@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

added Documentation/scsi/smartpqi.txt

Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 MAINTAINERS |    1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index f50fe50..d980685 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5447,6 +5447,7 @@ F:	drivers/scsi/smartpqi/Kconfig
 F:	drivers/scsi/smartpqi/Makefile
 F:	include/linux/cciss*.h
 F:	include/uapi/linux/cciss*.h
+F:	Documentation/scsi/smartpqi.txt
 
 HEWLETT-PACKARD SMART ARRAY RAID DRIVER (hpsa)
 M:	Don Brace <don.brace@microsemi.com>

