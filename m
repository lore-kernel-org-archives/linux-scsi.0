From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 0/7] megaraid_sas : Description Patch
Date: Mon, 10 Nov 2014 17:51:09 +0530
Message-ID: <201411101224.sAACOX9A018034@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0097.outbound.protection.outlook.com ([157.56.111.97]:9440
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751523AbaKJMzu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Nov 2014 07:55:50 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

megaraid_sas driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

---
[PATCH 0/7] megaraid_sas : Description Patch 
[PATCH 1/7] megaraid_sas : Driver version upgrade 
[PATCH 2/7] megaraid_sas : Update MAINTAINERS for megaraid drivers
[PATCH 3/7] megaraid_sas : Do not process IOCTLs and SCSI commands during driver removal
[PATCH 4/7] megaraid_sas : Online Firmware upgrade suppport for Extended VD feature
[PATCH 5/7] megaraid_sas : Make HBA operational after LD_MAP_SYNC DCMD in OCR path
[PATCH 6/7] megaraid_sas : Corrected return of wait_event from abort frame path
[PATCH 7/7] megaraid_sas : Endinaness related bug fixes
