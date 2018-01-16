From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH 0/8] qla2xxx: Minor fixes for the driver
Date: Mon, 15 Jan 2018 20:46:45 -0800
Message-ID: <20180116044653.20696-1-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0051.outbound.protection.outlook.com ([104.47.40.51]:14677
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750918AbeAPEq6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jan 2018 23:46:58 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Martin, 

This series has fixes for smatch warnings. Patch 3 addresses 
smatch warning reported by Dan Carpenter. We've also added a
patch for async abort handling for initiator multiqueue in the
driver along with a patch for NULL pointer access during probe 
failure.

Please apply this series to 4.16/scsi-queue at your earliest
convenience.

Thanks,
Himanshu 

Anil Gurumurthy (1):
  qla2xxx: Add XCB counters to debugfs

Darren Trapp (1):
  qla2xxx: Fix queue ID for async abort with Multiqueue

Himanshu Madhani (6):
  qla2xxx: Fix NULL pointer crash due to probe failure
  qla2xxx: Fix recursion while sending terminate exchange
  qla2xxx: Fix warning in qla2x00_async_iocb_timeout()
  qla2xxx: Fix warning during port_name debug print
  qla2xxx: Fix warning for code intentation in
    __qla24xx_handle_gpdb_event()
  qla2xxx: Update driver version to 10.00.00.05-k

 drivers/scsi/qla2xxx/qla_def.h     |  1 +
 drivers/scsi/qla2xxx/qla_dfs.c     |  9 +++++++++
 drivers/scsi/qla2xxx/qla_init.c    | 15 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_iocb.c    |  8 +++++---
 drivers/scsi/qla2xxx/qla_os.c      |  8 ++++----
 drivers/scsi/qla2xxx/qla_target.c  |  2 +-
 drivers/scsi/qla2xxx/qla_version.h |  2 +-
 7 files changed, 35 insertions(+), 10 deletions(-)

-- 
2.12.0
