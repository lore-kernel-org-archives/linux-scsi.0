From: Ching Huang <ching2048@areca.com.tw>
Subject: [PATCH v3 15/17] arcmsr: modify some character string
Date: Tue, 19 Aug 2014 15:22:45 +0800
Message-ID: <1408432965.4748.70.camel@Centos6.3-64>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Ching Huang <ching2048@areca.com.tw>

Revise comment and some character strings.

Signed-off-by: Ching Huang <ching2048@areca.com.tw>
---

diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
--- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:41:02.000000000 +0800
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:41:12.000000000 +0800
@@ -2,11 +2,10 @@
 *******************************************************************************
 **        O.S   : Linux
 **   FILE NAME  : arcmsr_hba.c
-**        BY    : Nick Cheng
-**   Description: SCSI RAID Device Driver for
-**                ARECA RAID Host adapter
+**        BY    : Nick Cheng, C.L. Huang
+**   Description: SCSI RAID Device Driver for Areca RAID Controller
 *******************************************************************************
-** Copyright (C) 2002 - 2005, Areca Technology Corporation All rights reserved
+** Copyright (C) 2002 - 2014, Areca Technology Corporation All rights reserved
 **
 **     Web site: www.areca.com.tw
 **       E-mail: support@areca.com.tw
@@ -70,8 +69,8 @@
 #include <scsi/scsi_transport.h>
 #include <scsi/scsicam.h>
 #include "arcmsr.h"
-MODULE_AUTHOR("Nick Cheng <support@areca.com.tw>");
-MODULE_DESCRIPTION("ARECA (ARC11xx/12xx/16xx/1880) SATA/SAS RAID Host Bus Adapter");
+MODULE_AUTHOR("Nick Cheng, C.L. Huang <support@areca.com.tw>");
+MODULE_DESCRIPTION("Areca ARC11xx/12xx/16xx/188x SAS/SATA RAID Controller Driver");
 MODULE_LICENSE("Dual BSD/GPL");
 MODULE_VERSION(ARCMSR_DRIVER_VERSION);
 
@@ -126,8 +125,7 @@ static int arcmsr_adjust_disk_queue_dept
 
 static struct scsi_host_template arcmsr_scsi_host_template = {
 	.module			= THIS_MODULE,
-	.name			= "ARCMSR ARECA SATA/SAS RAID Controller"
-				ARCMSR_DRIVER_VERSION,
+	.name			= "Areca SAS/SATA RAID driver",
 	.info			= arcmsr_info,
 	.queuecommand		= arcmsr_queue_command,
 	.eh_abort_handler		= arcmsr_abort,
@@ -3355,14 +3353,14 @@ static const char *arcmsr_info(struct Sc
 	case PCI_DEVICE_ID_ARECA_1680:
 	case PCI_DEVICE_ID_ARECA_1681:
 	case PCI_DEVICE_ID_ARECA_1880:
-		type = "SAS";
+		type = "SAS/SATA";
 		break;
 	default:
-		type = "X-TYPE";
+		type = "unknown";
+		raid6 =	0;
 		break;
 	}
-	sprintf(buf, "Areca %s Host Adapter RAID Controller%s\n %s",
-			type, raid6 ? "( RAID6 capable)" : "",
-			ARCMSR_DRIVER_VERSION);
+	sprintf(buf, "Areca %s RAID Controller %s\narcmsr version %s\n",
+		type, raid6 ? "(RAID6 capable)" : "", ARCMSR_DRIVER_VERSION);
 	return buf;
 }
