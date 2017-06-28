From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 0/3] cxlflash: Minor fix and EH refactoring
Date: Wed, 28 Jun 2017 12:12:09 -0500
Message-ID: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38987 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751492AbdF1RMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 13:12:31 -0400
Received: from pps.filterd (m0098399.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5SH9Ktj123304
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:12:31 -0400
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bcfq6jndr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:12:30 -0400
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 28 Jun 2017 13:12:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

This small series fixes a recently injected double free and also includes
two patches to refactor the host and reset handlers to ease the burden of
making this driver compatible with an updated SCSI EH framework.

This series is intended for 4.13 and is bisectable.

Matthew R. Ochs (3):
  cxlflash: Avoid double free of character device
  cxlflash: Update send_tmf() parameters
  cxlflash: Update debug prints in reset handlers

 drivers/scsi/cxlflash/main.c | 44 +++++++++++++++-----------------------------
 1 file changed, 15 insertions(+), 29 deletions(-)

-- 
2.1.0
