From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 0/8] megaraid_sas : Description Patch
Date: Mon, 5 Jan 2015 20:05:53 +0530
Message-ID: <201501051439.t05EdtBQ029946@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0090.outbound.protection.outlook.com ([207.46.100.90]:57364
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753292AbbAEPId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Jan 2015 10:08:33 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com

megaraid_sas driver changes.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>

---
[PATCH 0/8] megaraid_sas : Description Patch.
[PATCH 1/8] megaraid_sas : Endianness related bug fixes and code optimization.
[PATCH 2/8] megaraid_sas : Support for secure JBOD.
[PATCH 3/8] megaraid_sas : Fix the problem of non-existing VD exposed to host.
[PATCH 4/8] megaraid_sas : Disable interrupt_mask before enabling hardware interrupts.
[PATCH 5/8] megaraid_sas : Complete outstanding IOCTLs before killing adapter
[PATCH 6/8] megaraid_sas : Reserve commands for IOCTLs and internal DCMDs.
[PATCH 7/8] megaraid_sas : Remove redundant code of memset load_balance_info to zero.
[PATCH 8/8] megaraid_sas : Driver version update. 
