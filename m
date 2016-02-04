From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 0/4] qla2xxx: Patches for target-pending branch
Date: Thu, 4 Feb 2016 11:45:15 -0500
Message-ID: <1454604319-27947-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:15319 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934543AbcBDR15 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 12:27:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

Hi Nic, 

Please apply following patches to target-pending branch at your earliest
convenience.

Thanks,
Himanshu

Quinn Tran (3):
  qla2xxx: Fix stale pointer access.
  qla2xxx: Add DebugFS node for target sess list.
  qla2xxx: Add DebugFS node to show irq vector's cpuid

Swapnil Nagle (1):
  qla2xxx: Use ATIO type to send correct tmr response

 drivers/scsi/qla2xxx/qla_def.h    |    3 +
 drivers/scsi/qla2xxx/qla_dfs.c    |  104 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_init.c   |   10 ++--
 drivers/scsi/qla2xxx/qla_isr.c    |   20 ++++++-
 drivers/scsi/qla2xxx/qla_mid.c    |    4 +-
 drivers/scsi/qla2xxx/qla_os.c     |    6 ++
 drivers/scsi/qla2xxx/qla_target.c |   58 +++++++++++++-------
 drivers/scsi/qla2xxx/qla_tmpl.c   |   16 ++++++
 8 files changed, 192 insertions(+), 29 deletions(-)

-- 
1.7.7

