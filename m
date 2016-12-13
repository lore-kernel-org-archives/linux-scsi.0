From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: [PATCH v1 00/12] scsi: ufs: add trace/debug support, sysfs controls and few fixes
Date: Mon, 12 Dec 2016 16:52:00 -0800
Message-ID: <1481590321-32111-1-git-send-email-subhashj@codeaurora.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:57388 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751615AbcLMAwH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2016 19:52:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: vinholikatti@gmail.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Subhash Jadavani <subhashj@codeaurora.org>

This patch series adds following things:
 - ftrace support to trace important events in UFS driver.
 - debug dumps following failures to ease the debugging
 - sysfs node to control clock gating, clock scaling and PM
 - few fixes

Dolev Raviv (3):
  scsi: ufs: dump debug info during failures
  scsi: ufs: fix multiple ufs spec violation
  scsi: ufs: Improve fatal error logs

Lee Susman (1):
  scsi: ufs: add trace event for ufs commands

Sahitya Tummala (2):
  scsi: ufs: Add sysfs node to dynamically control clock gating
  scsi: ufs: Add sysfs node to dynamically control clock scaling

Subhash Jadavani (6):
  scsi: ufs: add tracing support
  scsi: ufs: provide sysfs attribute to select the PM level
  scsi: ufs: add option to change default UFS power management level
  scsi: ufs: add capability to keep auto bkops always enabled
  scsi: ufs: fix setting init power mode
  scsi: ufs: add time profiling support

 .../devicetree/bindings/ufs/ufshcd-pltfrm.txt      |  10 +
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |  14 +
 drivers/scsi/ufs/ufshcd.c                          | 831 +++++++++++++++++++--
 drivers/scsi/ufs/ufshcd.h                          |  74 +-
 drivers/scsi/ufs/ufshci.h                          |   3 +
 include/trace/events/ufs.h                         | 227 ++++++
 6 files changed, 1102 insertions(+), 57 deletions(-)
 create mode 100644 include/trace/events/ufs.h

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
a Linux Foundation Collaborative Project

