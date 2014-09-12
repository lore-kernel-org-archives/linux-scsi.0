From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 00/11] megaraid_sas : Description Patch
Date: Fri, 12 Sep 2014 18:57:08 +0530
Message-ID: <201409121329.s8CDTUJA022230@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:60593
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753661AbaILN1h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Sep 2014 09:27:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

MegaRaid driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>

---
[PATCH RESEND 00/11] megaraid_sas : Description Patch 
[PATCH RESEND 01/11] megaraid_sas : Do not scan non syspd drives. 
[PATCH RESEND 02/11] megaraid_sas : Use writeq for 64bit pci write to avoid spinlock overhead
[PATCH RESEND 03/11] megaraid_sas : Update threshold based reply post host index register
[PATCH RESEND 04/11] megaraid_sas : Firmware crash dump feature support
[PATCH RESEND 05/11] megaraid_sas : Extended VD support.
[PATCH RESEND 06/11] megaraid_sas : Host lock less mode to enabled asynchronous IO submission 
[PATCH RESEND 07/11] megaraid_sas : Round down max sge supported by controller to power of two
[PATCH RESEND 08/11] megaraid_sas : Add module parameter to disable IRQ-CPU affinity hint
[PATCH RESEND 09/11] megaraid_sas : N-drive primary raid level 1 load balancing
[PATCH RESEND 10/11] megaraid_sas : MFI MPT linked list corruption fix
[PATCH RESEND 11/11] megaraid_sas : Driver version update.
