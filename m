From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCHv2 0/3] qla2xxx, qla4xxx: re-use %p[hmM] specifiers to print variables
Date: Thu, 25 Jul 2013 12:10:22 +0300
Message-ID: <1374743425-13828-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39740 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755176Ab3GYJKh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jul 2013 05:10:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>, linux-driver@qlogic.com, linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

We have nice specifiers in the kernel that helps us to simplify printing of the
small buffers (as hexstring) and MAC addresses.

Since v1:
 - rewritten commit messages to reflect changes better
 - append patch 2/3
 - apply ACK to patch 3/3

Andy Shevchenko (1):
  scsi: qla2xxx: print MAC via %pMR

Oleksandr Khoshaba (2):
  scsi: qla2xxx: print some variables via %*phC or %*phN format
  scsi: qla4xxx: print MAC and SID via %p[mM][R]

 drivers/scsi/qla2xxx/qla_attr.c    |  5 +-
 drivers/scsi/qla2xxx/qla_bsg.c     |  8 +---
 drivers/scsi/qla2xxx/qla_gs.c      | 96 ++++++--------------------------------
 drivers/scsi/qla2xxx/qla_init.c    | 24 ++--------
 drivers/scsi/qla2xxx/qla_isr.c     |  9 +---
 drivers/scsi/qla2xxx/qla_mr.c      | 10 +---
 drivers/scsi/qla2xxx/qla_os.c      | 10 +---
 drivers/scsi/qla2xxx/qla_target.c  | 71 +++++++---------------------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c | 18 +++----
 drivers/scsi/qla4xxx/ql4_mbx.c     |  5 +-
 drivers/scsi/qla4xxx/ql4_nx.c      |  8 +---
 drivers/scsi/qla4xxx/ql4_os.c      | 15 ++----
 12 files changed, 60 insertions(+), 219 deletions(-)

-- 
1.8.3.2

