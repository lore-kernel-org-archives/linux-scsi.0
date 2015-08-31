From: sumit.saxena@avagotech.com
Subject: [PATCH v3 0/10] megaraid_sas : Updates for scsi for-next
Date: Mon, 31 Aug 2015 17:22:41 +0530
Message-ID: <201508311158.t7VBwALp031354@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.avagotech.com ([202.86.248.61]:41190 "EHLO
	sgpsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568AbbHaLyA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 07:54:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

MegaRaid driver changes. This patch set is rebased on top of below commit-

commit da0dc9fb4e6b0ad5a947c27a3c48985f6a2377eb
Author: Bjorn Helgaas <bhelgaas@google.com>
Date:   Tue Jul 7 15:52:45 2015 -0500

    megaraid_sas: fix whitespace errors


Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
[PATCH v3 00/10] megaraid_sas : Updates for scsi for-next.
[PATCH v3 01/10] megaraid_sas : Synchronize driver headers with firmware APIs.
[PATCH v3 02/10] megaraid_sas : Increase timeout to 60 secs for abort frames during shutdown.
[PATCH v3 03/10] megaraid_sas : Jbod sequence number support.
[PATCH v3 04/10] megaraid_sas : Code cleanup-use local variable drv_ops inside megasas_ioc_init_fusion.
[PATCH v3 05/10] megaraid_sas : Support for max_io_size 1MB.
[PATCH v3 06/10] megaraid_sas : Chip reset if driver fail to bring ioc ready.
[PATCH v3 07/10] megaraid_sas : Print critical fw event message.
[PATCH v3 08/10] megaraid_sas : Fix validHandles check in io path.
[PATCH v3 09/10] megaraid_sas : Code refactor for use of requestorId.
[PATCH v3 10/10] megaraid_sas : Version upgrade.


