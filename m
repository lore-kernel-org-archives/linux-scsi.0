From: akpm@linux-foundation.org
Subject: [patch 6/6] drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
Date: Tue, 10 Jan 2012 15:42:43 -0800
Message-ID: <20120110234243.D6ABE10014E@wpzn3.hot.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f202.google.com ([209.85.213.202]:42438 "EHLO
	mail-yx0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756633Ab2AJXmo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Jan 2012 18:42:44 -0500
Received: by yenm5 with SMTP id m5so18689yen.1
        for <linux-scsi@vger.kernel.org>; Tue, 10 Jan 2012 15:42:44 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org

From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly


Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/mpt2sas/mpt2sas_scsih.c~drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly drivers/scsi/mpt2sas/mpt2sas_scsih.c
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c~drivers-scsi-mpt2sas-mpt2sas_scsihc-spell-primitive-correctly
+++ a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -5744,7 +5744,7 @@ _scsih_sas_enclosure_dev_status_change_e
 }
 
 /**
- * _scsih_sas_broadcast_primative_event - handle broadcast events
+ * _scsih_sas_broadcast_primitive_event - handle broadcast events
  * @ioc: per adapter object
  * @fw_event: The fw_event_work object
  * Context: user.
@@ -5752,7 +5752,7 @@ _scsih_sas_enclosure_dev_status_change_e
  * Return nothing.
  */
 static void
-_scsih_sas_broadcast_primative_event(struct MPT2SAS_ADAPTER *ioc,
+_scsih_sas_broadcast_primitive_event(struct MPT2SAS_ADAPTER *ioc,
     struct fw_event_work *fw_event)
 {
 	struct scsi_cmnd *scmd;
@@ -7263,7 +7263,7 @@ _firmware_event_work(struct work_struct 
 		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_BROADCAST_PRIMITIVE:
-		_scsih_sas_broadcast_primative_event(ioc,
+		_scsih_sas_broadcast_primitive_event(ioc,
 		    fw_event);
 		break;
 	case MPI2_EVENT_SAS_ENCL_DEVICE_STATUS_CHANGE:
_
