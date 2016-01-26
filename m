From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: [PATCH 00/11] qla2xxx: Patches for scsi "misc" branch.
Date: Tue, 26 Jan 2016 12:10:35 -0500
Message-ID: <1453828246-28686-1-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:28362 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965234AbcAZR6I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Jan 2016 12:58:08 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, martin.petersen@oracle.com
Cc: giridhar.malavali@qlogic.com, himanshu.madhani@qlogic.com, linux-scsi@vger.kernel.org

Hi James, Martin,

Please apply following patches to the scsi tree, misc branch at your earliest
convenience. 

Thanks,
- Himanshu

Chad Dupuis (2):
  qla2xxx: Remove unneeded link offline message.
  qla2xxx: Set relogin flag when we fail to queue login requests.

Harish Zunjarrao (2):
  qla2xxx: Add support for Private link statistics counters.
  qla2xxx: Provide mbx info in BBCR data after mbx failure

Himanshu Madhani (3):
  qla2xxx: Allow fw to hold status before sending ABTS response.
  qla2xxx: Enable T10-DIF for ISP27XX
  qla2xxx: Update driver version to 8.07.00.33-k

Joe Carnuccio (2):
  qla2xxx: Seed init-cb login timeout from nvram exclusively.
  qla2xxx: Avoid side effects when using endianizer macros.

Sawan Chandak (2):
  qla2xxx: Add support for online flash update for ISP27XX.
  qla2xxx: Add support for buffer to buffer credit value for ISP27XX.

 drivers/scsi/qla2xxx/qla_attr.c    |   22 +++-
 drivers/scsi/qla2xxx/qla_bsg.c     |  201 ++++++++++++++++++++++++++++++++++++
 drivers/scsi/qla2xxx/qla_bsg.h     |   34 ++++++
 drivers/scsi/qla2xxx/qla_dbg.c     |  146 ++++++++++++++------------
 drivers/scsi/qla2xxx/qla_def.h     |   56 ++++++++++-
 drivers/scsi/qla2xxx/qla_fw.h      |   14 +++-
 drivers/scsi/qla2xxx/qla_gbl.h     |    2 +
 drivers/scsi/qla2xxx/qla_init.c    |  119 ++++++++++++++++++++--
 drivers/scsi/qla2xxx/qla_inline.h  |    4 +-
 drivers/scsi/qla2xxx/qla_isr.c     |    4 -
 drivers/scsi/qla2xxx/qla_mbx.c     |   27 +++--
 drivers/scsi/qla2xxx/qla_os.c      |   10 ++
 drivers/scsi/qla2xxx/qla_sup.c     |   70 ++++++++++---
 drivers/scsi/qla2xxx/qla_version.h |    2 +-
 14 files changed, 594 insertions(+), 117 deletions(-)

-- 
1.7.7

