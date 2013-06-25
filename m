From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 00/16] qla2xxx: Patches for scsi "misc" branch.
Date: Tue, 25 Jun 2013 11:27:15 -0400
Message-ID: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:52287 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752130Ab3FYPxw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:52 -0400
Received: from mail227-tx2 (localhost [127.0.0.1])	by
 mail227-tx2-R.bigfish.com (Postfix) with ESMTP id 9171FAC018F	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:51 +0000 (UTC)
Received: from TX2EHSMHS027.bigfish.com (unknown [10.9.14.244])	by
 mail227-tx2.bigfish.com (Postfix) with ESMTP id 263C1320069	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:49 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Hi James,

Please apply the following patches to the scsi tree at your earliest
convenience for inclusion in the next mainline merge window.

Thanks,
~Saurav


Bart Van Assche (10):
  qla2xxx: Clean up qla24xx_iidma()
  qla2xxx: Clean up qla84xx_mgmt_cmd()
  qla2xxx: Remove dead code in qla2x00_configure_hba()
  qla2xxx: Remove two superfluous tests.
  qla2xxx: Remove a dead assignment in
    qla24xx_build_scsi_crc_2_iocbs().
  qla2xxx: Remove redundant assignments.
  qla2xxx: Help Coverity with analyzing ct_sns_pkt initialization.
  qla2xxx: Fix qla2xxx_check_risc_status().
  qla2xxx: Remove an unused variable from qla2x00_remove_one().
  qla2xxx: Fix a memory leak in an error path of qla2x00_process_els()

Chad Dupuis (2):
  qla2xxx: Do not query FC statistics during chip reset.
  qla2xxx: Do not take a second firmware dump when intentionally
    generating one.

Giridhar Malavali (2):
  qla2xxx: Clear the MBX_INTR_WAIT flag when the mailbox time-out
    happens.
  qla2xxx: Set the index in outstanding command array to NULL when cmd
    is aborted when the request timeout.

Saurav Kashyap (2):
  qla2xxx: Move qla2x00_free_device to the correct location.
  qla2xxx: Fix sparse warning from qla_mr.c and qla_iocb.c.

 drivers/scsi/qla2xxx/qla_attr.c   |    5 +-
 drivers/scsi/qla2xxx/qla_bsg.c    |   38 +++------
 drivers/scsi/qla2xxx/qla_dbg.c    |   12 ++-
 drivers/scsi/qla2xxx/qla_def.h    |   34 ++++----
 drivers/scsi/qla2xxx/qla_gbl.h    |    2 +-
 drivers/scsi/qla2xxx/qla_gs.c     |   86 +++++++++----------
 drivers/scsi/qla2xxx/qla_init.c   |    8 --
 drivers/scsi/qla2xxx/qla_inline.h |    2 +-
 drivers/scsi/qla2xxx/qla_iocb.c   |    6 +-
 drivers/scsi/qla2xxx/qla_isr.c    |    1 +
 drivers/scsi/qla2xxx/qla_mbx.c    |   16 +++-
 drivers/scsi/qla2xxx/qla_mr.c     |  167 +++++++++++++++++++------------------
 drivers/scsi/qla2xxx/qla_mr.h     |   98 +++++++++++-----------
 drivers/scsi/qla2xxx/qla_os.c     |   10 +--
 14 files changed, 235 insertions(+), 250 deletions(-)

-- 
1.7.7


