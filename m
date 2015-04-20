From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 0/18] megaraid_sas : Description Patch
Date: Mon, 20 Apr 2015 18:02:20 +0530
Message-ID: <201504201234.t3KCYWc1016305@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:15120
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754852AbbDTMrq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 08:47:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

This patch series for megaraid_sas driver is resent with splitting one patch in to 5 different patches(patch #1 to patch #5) along with few extra sparse warnings fixes (patch#10 to patch #18). These sparse warnings fixes are also not first time submitted but resent(earlier sent by Christoph Hellwig).

Please consider this patch series for next release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

---
[PATCH RESEND 0/18] megaraid_sas : Description Patch.
[PATCH RESEND 1/18] megaraid_sas : Add separate function for setting up IRQs.
[PATCH RESEND 2/18] megaraid_sas : Add separate function for refiring MFI commands.
[PATCH RESEND 3/18] megaraid_sas : Add separate functions for building sysPD IOs and non RW LDIOs.
[PATCH RESEND 4/18] megaraid_sas : Move controller's queue depth calculation in adapter specific function.
[PATCH RESEND 5/18] megaraid_sas : Enhanced few prints.
[PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support for internal command indexing.
[PATCH RESEND 7/18] megaraid_sas : Modify driver's meta data to reflect Avago. 
[PATCH RESEND 8/18] megaraid_sas : Add release date and update driver version.
[PATCH RESEND 9/18] megaraid_sas : Support for Avago's Single server High Availability product.
[PATCH RESEND 10/18] megaraid_sas : megasas_complete_outstanding_ioctls() can be static.
[PATCH RESEND 11/18] megaraid_sas : add missing __iomem annotations.
[PATCH RESEND 12/18] megaraid_sas : add endianess annotations.
[PATCH RESEND 13/18] megaraid_sas : add endianess conversions for all ones.
[PATCH RESEND 14/18] megaraid_sas : move endianess conversion into caller of megasas_get_seq_num.
[PATCH RESEND 15/18] megaraid_sas : bytewise or should be done on native endian variables.
[PATCH RESEND 16/18] megaraid_sas : add missing byte swaps to the sriov code.
[PATCH RESEND 17/18] megaraid_sas : fix megasas_fire_cmd_fusion calling convention
[PATCH RESEND 18/18] megaraid_sas : swap whole register in megasas_register_aen.
