From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 00/11] megaraid_sas : Description Patch
Date: Sat, 6 Sep 2014 18:55:44 +0530
Message-ID: <201409061328.s86DS2ss012698@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0079.outbound.protection.outlook.com ([157.56.111.79]:62208
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751164AbaIFNlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 6 Sep 2014 09:41:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, aradford@gmail.com

MegaRaid driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

---
[PATCH 00/11] megaraid_sas : Description Patch 
[PATCH 01/11] megaraid_sas : Do not scan non syspd drives. 
[PATCH 02/11] megaraid_sas : Use writeq for 64bit pci write to avoid spinlock overhead
[PATCH 03/11] megaraid_sas : Update threshold based reply post host index register
[PATCH 04/11] megaraid_sas : Firmware crash dump feature support
[PATCH 05/11] megaraid_sas : Extended VD support.
[PATCH 06/11] megaraid_sas : Host lock less mode to enabled asynchronous IO submission 
[PATCH 07/11] megaraid_sas : Round down max sge supported by controller to power of two
[PATCH 08/11] megaraid_sas : Add module parameter to disable IRQ-CPU affinity hint
[PATCH 09/11] megaraid_sas : N-drive primary raid level 1 load balancing
[PATCH 10/11] megaraid_sas : MFI MPT linked list corruption fix
[PATCH 11/11] megaraid_sas : Driver version update.
