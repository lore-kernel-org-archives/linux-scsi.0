From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: [PATCH v1 0/3] Ibmvscsis fixes and code cleanup
Date: Wed, 31 Aug 2016 11:28:58 -0500
Message-ID: <1472660941-23856-1-git-send-email-bryantly@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50430 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S935769AbcHaQ3N (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 12:29:13 -0400
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7VGMpNf134566
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:12 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 255q3sewrj-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 12:29:12 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
        Wed, 31 Aug 2016 10:29:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, dan.carpenter@oracle.com
Cc: mikecyr@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>

Here are some small fixes and cleanups for Ibmvscsis Target Driver.
The only one of significance is the first one where there is a
possibility of a kernel crash due to inproper deregister of target
session since we didn't sync up work and didn't deregister_configfs.

Bryant G. Ly (3):
  Ibmvscsis: Properly deregister target sessions
  Ibmvscsis: Code cleanup of print statements
  Ibmvscsis: Fixed a bug reported by Dan Carpenter

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 30 +++++-------------------------
 1 file changed, 5 insertions(+), 25 deletions(-)

-- 
2.5.4 (Apple Git-61)

