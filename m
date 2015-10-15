From: sumit.saxena@avagotech.com
Subject: [PATCH 0/12] megaraid_sas : Updates for scsi for-next
Date: Thu, 15 Oct 2015 13:39:14 +0530
Message-ID: <201510150816.t9F8GWC6029536@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rndsmtp1.avagotech.com ([202.86.248.48]:60864 "EHLO
	rndsmtp1.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420AbbJOIPl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Oct 2015 04:15:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com, uday.lingala@avagotech.com

This patch set is rebased on top of last patch set sent by me- http://marc.info/?l=linux-scsi&m=144102204225400&w=2
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
[PATCH 00/12] megaraid_sas : Updates for scsi for-next.
[PATCH 01/12] megaraid_sas : Expose TAPE drives unconditionally.
[PATCH 02/12] megaraid_sas : Code optimization- remove PCI Ids based checks.
[PATCH 03/12] megaraid_sas : Support for Intruder(12 Gbps) controller.
[PATCH 04/12] megaraid_sas : Support for Cutlass(12 Gbps) controller.
[PATCH 05/12] megaraid_sas : Donot use PAGE_SIZE macro for calculation of max_sectors per IO request.
[PATCH 06/12] megaraid_sas : Update OCR capability on controller properties change.  
[PATCH 07/12] megaraid_sas : Online firmware Upgrade support for Secure JBOD feature.
[PATCH 08/12] megaraid_sas : Initialize tasklet before setting up IRQs.
[PATCH 09/12] megaraid_sas : Make PI enabled VD 8 byte DMA aligned.
[PATCH 10/12] megaraid_sas : SMAP restriction-do not access user memory from IOCTL code.
[PATCH 11/12] megaraid_sas : Driver version upgrade.
[PATCH 12/12] megaraid_sas : Remove debug print from function megasas_update_span_set.


