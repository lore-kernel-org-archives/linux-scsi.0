From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/1] cxlflash: Fix in EEH recovery
Date: Wed, 15 Jun 2016 18:46:36 -0500
Message-ID: <1466034396-17736-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:30758 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752819AbcFOXq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Jun 2016 19:46:59 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5FNi44d130267
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:46:58 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23jgmpf2e7-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jun 2016 19:46:58 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Wed, 15 Jun 2016 17:46:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch addresses a deadlock issue seen during EEH recovery
and is intended for 4.7.

Manoj N. Kumar (1):
  cxlflash: Fix to resolve dead-lock during EEH recovery

 drivers/scsi/cxlflash/superpipe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.1.0

