From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 0/1] cxlflash: Fix in EEH recovery
Date: Tue,  3 May 2016 11:26:41 -0500
Message-ID: <1462292801-33954-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:57251 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932543AbcECQ2L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2016 12:28:11 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
	Tue, 3 May 2016 10:28:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch addresses a deadlock issue seen during EEH recovery
and is intended for 4.7.

Manoj N. Kumar (1):
  cxlflash: Fix to resolve dead-lock during EEH recovery

 drivers/scsi/cxlflash/superpipe.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

-- 
2.1.0

