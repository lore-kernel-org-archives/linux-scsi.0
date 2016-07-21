From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/2] cxlflash: Regression patch and updating Maintainers list
Date: Thu, 21 Jul 2016 15:42:52 -0500
Message-ID: <1469133772-14953-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:63773 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753877AbcGUUnp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2016 16:43:45 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u6LKdBfK003108
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:43:44 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24as6gc1r6-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 21 Jul 2016 16:43:44 -0400
Received: from localhost
	by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Thu, 21 Jul 2016 14:43:43 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

First patch in this set fixes a regression that was casued by the
Commit 704c4b0ddc03 ("cxlflash: Shutdown notify support for CXL
Flash cards"), which is currently staged for 4.8 in next/master.
Second patch updates the Maintainers list for cxlflash driver.

This series is intended for 4.8 and is bisectable. These patches
are cut against next/master that contains the original commit.

Uma Krishnan (2):
  cxlflash: Verify problem state area is mapped before notifying
    shutdown
  MAINTAINERS: Update cxlflash maintainers

 MAINTAINERS                  |  1 +
 drivers/scsi/cxlflash/main.c | 10 +++++++++-
 2 files changed, 10 insertions(+), 1 deletion(-)

-- 
2.1.0

