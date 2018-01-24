From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/6] Six qla2xxx and qla4xxx patches
Date: Tue, 23 Jan 2018 16:33:45 -0800
Message-ID: <20180124003351.2616-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:51749 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752455AbeAXAdv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2018 19:33:51 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Himanshu Madhani <himanshu.madhani@cavium.com>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

The patches in this series are what I came up with after having analyzed
the source code of the qla[24]xxx drivers with several source code analysis
tools (scripts/kernel-doc, gcc, sparse and smatch). None of the patches in
this series have been tested. Yet I'm asking you to consider at least the
first patch of this series for kernel v4.16 because it fixes a locking bug
in one of the SCSI patches queued for kernel v4.16.

Thanks,

Bart.

Bart Van Assche (6):
  qla2xxx: Fix a locking imbalance in qlt_24xx_handle_els()
  qla2xxx: Use %p for printing pointers
  qla2xxx: Remove unused symbols
  qla4xxx: Remove unused symbols
  qla4xxx: Move an array from a .h into a .c file
  qla2xxx: Fix function argument descriptions

 drivers/scsi/qla2xxx/qla_dbg.c    |  4 +-
 drivers/scsi/qla2xxx/qla_gs.c     | 78 +++++++++++++++++++--------------------
 drivers/scsi/qla2xxx/qla_init.c   | 37 ++++++++++---------
 drivers/scsi/qla2xxx/qla_inline.h |  1 +
 drivers/scsi/qla2xxx/qla_iocb.c   | 15 ++++++--
 drivers/scsi/qla2xxx/qla_isr.c    | 23 +++++++-----
 drivers/scsi/qla2xxx/qla_mbx.c    |  5 ++-
 drivers/scsi/qla2xxx/qla_mr.c     | 36 ++++++++++--------
 drivers/scsi/qla2xxx/qla_nx.c     |  7 ++--
 drivers/scsi/qla2xxx/qla_nx2.c    | 19 +++++-----
 drivers/scsi/qla2xxx/qla_nx2.h    |  4 --
 drivers/scsi/qla2xxx/qla_sup.c    |  1 +
 drivers/scsi/qla2xxx/qla_target.c |  9 ++---
 drivers/scsi/qla4xxx/ql4_nx.c     |  2 +
 drivers/scsi/qla4xxx/ql4_nx.h     |  7 ----
 15 files changed, 129 insertions(+), 119 deletions(-)

-- 
2.15.1
