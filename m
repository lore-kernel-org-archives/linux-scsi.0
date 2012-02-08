From: akpm@linux-foundation.org
Subject: [patch 3/4] drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly
Date: Wed, 08 Feb 2012 12:52:22 -0800
Message-ID: <20120208205222.5C19AA03DE@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f74.google.com ([209.85.161.74]:45210 "EHLO
	mail-fx0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab2BHU7n (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2012 15:59:43 -0500
Received: by faaa19 with SMTP id a19so32312faa.1
        for <linux-scsi@vger.kernel.org>; Wed, 08 Feb 2012 12:59:42 -0800 (PST)
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
