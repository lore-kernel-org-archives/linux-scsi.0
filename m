From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 0/7] megaraid_sas : Description Patch
Date: Mon, 17 Nov 2014 15:23:52 +0530
Message-ID: <201411170957.sAH9vYLa008937@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0069.outbound.protection.outlook.com ([157.56.110.69]:32437
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751814AbaKQJyN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2014 04:54:13 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

megaraid_sas driver changes.
This resent patch series has some additional changes in few patches on top of last patch series.
[PATCH RESNED 1/7] additionally rmeoves some meta data of megaraid_sas driver.
[PATCH RESEND 2/7] has additional copyright changes as well.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

---
[PATCH RESEND 0/7] megaraid_sas : Description Patch.
[PATCH RESEND 1/7] megaraid_sas : Driver version upgrade and remove some meta data of driver.
[PATCH RESEND 2/7] megaraid_sas : Update MAINTAINERS and copyright information for megaraid drivers.
[PATCH RESEND 3/7] megaraid_sas : Do not process IOCTLs and SCSI commands during driver removal.
[PATCH RESEND 4/7] megaraid_sas : Online Firmware upgrade support for Extended VD feature.
[PATCH RESEND 5/7] megaraid_sas : Make HBA operational after LD_MAP_SYNC DCMD in OCR path.
[PATCH RESEND 6/7] megaraid_sas : Corrected return of wait_event from abort frame path.
[PATCH RESEND 7/7] megaraid_sas : Endinaness related bug fixes.
