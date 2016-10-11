From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v1 0/3] Fixes for problems found during testing
Date: Tue, 11 Oct 2016 17:58:02 -0500
Message-ID: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:50003 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1754462AbcJKW6T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 11 Oct 2016 18:58:19 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9BMrkad081118
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2016 18:58:18 -0400
Received: from e32.co.us.ibm.com (e32.co.us.ibm.com [32.97.110.150])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2615bmgw5h-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 11 Oct 2016 18:58:18 -0400
Received: from localhost
        by e32.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Tue, 11 Oct 2016 16:58:17 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

The first one seems bigger than it is, because I needed to rearrange the
order of some functions.

Michael Cyr (3):
  Synchronization of cmds during termination conditions
  Properly handle if target_submit_cmd/tmr fails
  Return correct partition name/number to client

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1076 ++++++++++++++----------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |    5 +-
 2 files changed, 488 insertions(+), 593 deletions(-)

-- 
2.5.0

