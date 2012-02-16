From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: [patch 3/4] drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell
 "primitive" correctly
Date: Thu, 16 Feb 2012 10:44:19 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6067E49FF81@inbmail02.lsi.com>
References: <20120208205222.5C19AA03DE@akpm.mtv.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:51006 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750941Ab2BPFOZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Feb 2012 00:14:25 -0500
In-Reply-To: <20120208205222.5C19AA03DE@akpm.mtv.corp.google.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

This patch seem to be fine. Please consider this patch as Acked-by: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of akpm@linux-foundation.org
Sent: Thursday, February 09, 2012 2:22 AM
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org; akpm@linux-foundation.org
Subject: [patch 3/4] drivers/scsi/mpt2sas/mpt2sas_scsih.c: spell "primitive" correctly

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
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
