From: Michael Cyr <mikecyr@us.ibm.com>
Subject: [PATCH v2 0/6] Fixes for ibmvscsis driver
Date: Thu, 13 Oct 2016 11:02:37 -0500
Message-ID: <1476374563-13967-1-git-send-email-mikecyr@us.ibm.com>
References: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:48633 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S932150AbcJMRUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Oct 2016 13:20:54 -0400
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id u9DFx2f8140777
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:05 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 262b6g9qt4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 13 Oct 2016 12:03:05 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mikecyr@us.ibm.com>;
        Thu, 13 Oct 2016 10:03:04 -0600
In-Reply-To: <1476226685-2276-1-git-send-email-mikecyr@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org, joe@perches.com
Cc: hch@infradead.org, bryantly@linux.vnet.ibm.com, James.Bottomley@HansenPartnership.com, tyreld@linux.vnet.ibm.com, brking@linux.vnet.ibm.com, akpm@linux-foundation.org, bart.vanassche@sandisk.com, gregkh@linuxfoundation.org, seroyer@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, martin.petersen@oracle.com, Michael Cyr <mikecyr@us.ibm.com>

Various fixes and cleanups for the ibmvscsis driver.
The first is a sort of prequel to the second, which is the primary
change (and the biggest).  The rest are fairly small fixes.

Michael Cyr (6):
  ibmvscsis: Rearrange functions for future patches
  ibmvscsis: Synchronize cmds at tpg_enable_store time
  ibmvscsis: Synchronize cmds at remove time
  ibmvscsis: Clean up properly if target_submit_cmd/tmr fails
  ibmvscsis: Return correct partition name/# to client
  ibmvscsis: Issues from Dan Carpenter/Smatch

 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c | 1096 +++++++++++++-----------------
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h |    5 +-
 2 files changed, 494 insertions(+), 607 deletions(-)

-- 
2.5.0

