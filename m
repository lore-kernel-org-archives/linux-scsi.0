From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 0/2] qla2xxx: Fixes for target-pending
Date: Wed, 10 Feb 2016 18:59:12 -0500
Message-ID: <1455148754-17330-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32730 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751210AbcBKAmF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 10 Feb 2016 19:42:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, nab@linux-iscsi.org
Cc: giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org, himanshu.madhani@qlogic.com

Hi Nic, 

Here are the patches that addresses review comments from Bart
and Christoph. See email threads

 http://www.spinics.net/lists/target-devel/msg11418.html
 http://www.spinics.net/lists/target-devel/msg11419.html

Please apply these patches to target-pending.

Thanks,
Himanshu

Quinn Tran (2):
  target/transport: add flag to indicate CPU Affinity is observed
  qla2xxx: use TARGET_SCF_USE_CPUID flag to indiate CPU Affinity

 drivers/scsi/qla2xxx/qla_target.c      |    4 ++--
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |    3 +++
 drivers/target/target_core_transport.c |   12 +++++++++---
 include/target/target_core_base.h      |    2 ++
 4 files changed, 16 insertions(+), 5 deletions(-)

-- 
1.7.7

