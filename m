From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH 0/7] megaraid_sas : Updates for scsi for-next
Date: Fri, 7 Aug 2015 17:54:27 +0530
Message-ID: <201508071230.t77CUiQg021206@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sgpsmtp2.avagotech.com ([199.3.246.86]:60082 "EHLO
	sgpsmtp2.avagotech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbbHGMfp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2015 08:35:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, kiran-kumar.kasturi@avagotech.com
Cc: uday.lingala@avagotech.com

MegaRaid driver changes.
Please consider this patch set for next kernel release.

Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>
---
[PATCH 00/07] megaraid_sas : Updates for scsi for-next
[PATCH 01/07] megaraid_sas : Jbod sequence number support 
[PATCH 02/07] megaraid_sas : Support for max_io_size 1MB
[PATCH 03/07] megaraid_sas : Chip reset if driver fail to bring ioc ready 
[PATCH 04/07] megaraid_sas : Print critical fw event message 
[PATCH 05/07] megaraid_sas : Fix validHandles check in io path
[PATCH 06/07] megaraid_sas : Code refactor for use of requestorId
[PATCH 07/07] megaraid_sas : Version upgrade


