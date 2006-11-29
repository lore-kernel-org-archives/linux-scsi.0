From: Chip Coldwell <coldwell@redhat.com>
Subject: [2.6 PATCH] sym53c8xx_2 claims cpqarray device
Date: Wed, 29 Nov 2006 12:56:38 -0500
Message-ID: <rzpbqmqi1bd.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:45982 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S967493AbWK2R4e (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Nov 2006 12:56:34 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kATHuXN8029455
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2006 12:56:33 -0500
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.13.1/8.13.1) with ESMTP id kATHuXkM009986
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2006 12:56:33 -0500
Received: from localhost.localdomain (dhcp83-29.boston.redhat.com [172.16.83.29])
	by mail.boston.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id kATHuW5T014075
	for <linux-scsi@vger.kernel.org>; Wed, 29 Nov 2006 12:56:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Apropos this thread

http://marc.theaimsgroup.com/?l=linux-scsi&m=115591706804045&w=2

which led to this patch

http://www.kernel.org/git/?p=linux/kernel/git/jejb/scsi-rc-fixes-2.6.git;a=commit;h=b2b3c121076961333977f485f0d54c22121df920

do we not also need the following patch, nine lines lower in the same file?

Signed-off-by: chip Coldwell <coldwell@redhat.com>

--- linux-2.6.18/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-09-20 09:12:06.000000000 +0530
+++ linux-2.6.18/drivers/scsi/sym53c8xx_2/sym_glue.c	2006-10-10 19:14:56.000000000 +0530
@@ -2094,7 +2094,7 @@
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C875,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_NCR_53C1510,
-	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL }, /* new */
+	  PCI_ANY_ID, PCI_ANY_ID,  PCI_CLASS_STORAGE_SCSI<<8,  0xffff00, 0UL }, /* new */
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C895A,
 	  PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0UL },
 	{ PCI_VENDOR_ID_LSI_LOGIC, PCI_DEVICE_ID_LSI_53C875A,

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc.
1-978-392-2426
