From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH v2 0/5] bnx2fc: Update driver to version 2.10.3.
Date: Thu, 7 Apr 2016 09:07:55 -0400
Message-ID: <1460034480-28512-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:44604 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753065AbcDGNtY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Apr 2016 09:49:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: chad.dupuis@qlogic.com, saurav.kashyap@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Martin,

Please apply the patch series for the next merge window at your earliest
convenience.

V2 changes:

- Made netdev device name print pr_info instead of pr_err.
- Made TMF timeout settable via sysfs node instead of modparam.

Thanks,
Chad

Chad Dupuis (4):
  bnx2fc: Print when we send a fip keep alive.
  bnx2fc: Print netdev device name when FCoE is successfully
    initialized.
  bnx2fc: Check sc_cmd device and host pointer before returning the
    command to the mid-layer.
  bnx2fc: Update version number to 2.10.3.

Joe Carnuccio (1):
  bnx2fc: Add driver tunables.

 drivers/scsi/bnx2fc/bnx2fc.h      |   3 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c | 100 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/bnx2fc/bnx2fc_io.c   |  14 +++++-
 3 files changed, 114 insertions(+), 3 deletions(-)

-- 
2.0.0.rc0.26.g779792a

