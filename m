From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 0/8] scsi: ufs: enhancements, bug fixes and debug support
Date: Fri,  3 Feb 2017 16:56:30 -0800
Message-ID: <1486169790-22655-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:43760 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753138AbdBDA4h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Feb 2017 19:56:37 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>

This patch series adds following things:
 - Gear scaling during clock scaling to save additional power
 - Make clock scaling independent clock gating so that we can set lower
   clock gating timeout than clock scaling window
 - one bug fix to clock scaling
 - additional debug support

Gilad Broner (3):
  scsi: ufs: skip request abort task when previous aborts failed
  scsi: ufs: reduce printout for aborted requests
  scsi: ufs: add host state prints in failure cases

Subhash Jadavani (3):
  scsi: ufs: add load based scaling of UFS gear
  scsi: ufs: don't suspend clock scaling during clock gating
  scsi: ufs: kick start clock scaling only after device detection

Venkat Gopalakrishnan (2):
  scsi: ufs-qcom: dump additional testbus registers
  scsi: ufs: dump hw regs on link failures

 drivers/scsi/ufs/ufs-qcom.c |  48 ++-
 drivers/scsi/ufs/ufs-qcom.h |   1 +
 drivers/scsi/ufs/ufshcd.c   | 863 ++++++++++++++++++++++++++++++++------------
 drivers/scsi/ufs/ufshcd.h   |  44 ++-
 4 files changed, 726 insertions(+), 230 deletions(-)

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project
