From: Himanshu Madhani <himanshu.madhani@cavium.com>
Subject: [PATCH v2 00/10] qla2xxx: Bug fixes for driver.
Date: Wed, 21 Dec 2016 13:57:29 -0800
Message-ID: <1482357459-31079-1-git-send-email-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0069.outbound.protection.outlook.com ([104.47.37.69]:31104
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754340AbcLUV6P (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 16:58:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org
Cc: giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com

Hi Christoph, Bart,

Here's updated series of bug fixes for target code in the driver.
Please consider this for target-pending.

Changes from v1 --> v2

o Updated patches to remove braces. 
o Added description for the patch reqeusted.

Thanks,
Himanshu

Himanshu Madhani (3):
  qla2xxx: Include ATIO queue in firmware dump when in target mode
  qla2xxx: Set tcm_qla2xxx version to automatically track qla2xxx
    version.
  qla2xxx: Reset reserved field in firmware options to 0.

Quinn Tran (7):
  qla2xxx: Fix wrong IOCB type assumption.
  qla2xxx: Collect additional information to debug fw dump.
  qla2xxx: Fix crash due to null pointer access.
  qla2xxx: Terminate exchange if corrputed.
  qla2xxx: Reduce exess wait during chip reset
  qla2xxx: Fix invalid handle erroneous message.
  qla2xxx: Disable Out-of-order processing by default in Firmware

 drivers/scsi/qla2xxx/qla_def.h     |  3 ++-
 drivers/scsi/qla2xxx/qla_init.c    |  4 +--
 drivers/scsi/qla2xxx/qla_isr.c     |  4 +++
 drivers/scsi/qla2xxx/qla_mbx.c     | 27 ++++++++++++++-----
 drivers/scsi/qla2xxx/qla_os.c      | 23 +++++++++++++---
 drivers/scsi/qla2xxx/qla_target.c  | 55 +++++++++++++++++++++++++-------------
 drivers/scsi/qla2xxx/qla_target.h  | 22 ++++++++++++++-
 drivers/scsi/qla2xxx/qla_tmpl.c    | 24 +++++++++++++++++
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  4 +--
 drivers/scsi/qla2xxx/tcm_qla2xxx.h |  1 -
 10 files changed, 131 insertions(+), 36 deletions(-)

-- 
1.8.3.1

