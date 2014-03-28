From: Quinn Tran <quinn.tran@qlogic.com>
Subject: [PATCH RFC 0/4] add T10-Dif registration for tcm_qla2xxx
Date: Fri, 28 Mar 2014 19:05:23 -0400
Message-ID: <1396047927-14189-1-git-send-email-quinn.tran@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:13551 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751293AbaC1XmI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2014 19:42:08 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com

Nicholas,

Per our conversation at LSF, the following are the patch set
of bug fix/tweak found during T10-Dif testing and add ability
for QLogic FC driver to register with TCM its T10-PI capabilities.  

As for the rest of the other patches that does the actual
T10-Dif data movement, I will submit them to target-devel and
stable kernel.

Quinn
-----
Quinn Tran (4):
  target/core: T10-Dif: check HW support capabilities
  tcm_qla2xxx: T10-Dif set harware capability
  target/rd: T10-Dif: Add init/format support
  target/rd: T10-Dif: RAM disk is allocating more space than required.

 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 23 +++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.h           |  1 +
 drivers/target/target_core_fabric_configfs.c | 20 ++++++++
 drivers/target/target_core_rd.c              | 70 +++++++++++++++++++++++++++-
 drivers/target/target_core_tpg.c             |  9 ++++
 include/target/target_core_base.h            | 14 ++++++
 include/target/target_core_fabric.h          |  1 +
 7 files changed, 136 insertions(+), 2 deletions(-)

-- 
1.8.4.GIT

