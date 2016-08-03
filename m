From: Tyrel Datwyler <tyreld@linux.vnet.ibm.com>
Subject: [PATCH 0/2] ibmvfc: FC-TAPE Support
Date: Wed,  3 Aug 2016 16:36:51 -0500
Message-ID: <1470260213-19087-1-git-send-email-tyreld@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:10495 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755188AbcHCVhP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Aug 2016 17:37:15 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u73LYCmY005340
	for <linux-scsi@vger.kernel.org>; Wed, 3 Aug 2016 17:37:04 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
	by mx0a-001b2d01.pphosted.com with ESMTP id 24kkagn5gs-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 03 Aug 2016 17:37:04 -0400
Received: from localhost
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <tyreld@linux.vnet.ibm.com>;
	Wed, 3 Aug 2016 17:37:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, brking@linux.vnet.ibm.com, nfont@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mpe@ellerman.id.au, Tyrel Datwyler <tyreld@linux.vnet.ibm.com>

This patchset introduces optional FC-TAPE/FC Class 3 Error Recovery to the
ibmvfc client driver.

Tyrel Datwyler (2):
  ibmvfc: Set READ FCP_XFER_READY DISABLED bit in PRLI
  ibmvfc: add FC Class 3 Error Recovery support

 drivers/scsi/ibmvscsi/ibmvfc.c | 11 +++++++++++
 drivers/scsi/ibmvscsi/ibmvfc.h |  1 +
 2 files changed, 12 insertions(+)

-- 
2.7.4

