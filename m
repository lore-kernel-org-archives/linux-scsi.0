From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v2 0/10] megaraid_sas : Updates for scsi for-next
Date: Thu, 20 Aug 2015 18:43:39 +0530
Message-ID: <201508201319.t7KDJDpc028522@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [199.3.246.86] ([199.3.246.86]:57240 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752111AbbHTNOK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Aug 2015 09:14:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

MegaRaid driver changes. This patch set is resent based on feedback received by Martin Petersen.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
[PATCH v2 00/10] megaraid_sas : Updates for scsi for-next.
[PATCH v2 01/10] megaraid_sas : Synchronize driver headers with firmware APIs.
[PATCH v2 02/10] megaraid_sas : Increase timeout to 60 secs for abort frames during shutdown.
[PATCH v2 03/10] megaraid_sas : Jbod sequence number support.
[PATCH v2 04/10] megaraid_sas : Code cleanup-use local variable drv_ops inside megasas_ioc_init_fusion.
[PATCH v2 05/10] megaraid_sas : Support for max_io_size 1MB.
[PATCH v2 06/10] megaraid_sas : Chip reset if driver fail to bring ioc ready.
[PATCH v2 07/10] megaraid_sas : Print critical fw event message.
[PATCH v2 08/10] megaraid_sas : Fix validHandles check in io path.
[PATCH v2 09/10] megaraid_sas : Code refactor for use of requestorId.
[PATCH v2 10/10] megaraid_sas : Version upgrade.


