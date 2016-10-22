From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v3 0/6] scsi: collection of clean ups
Date: Sat, 22 Oct 2016 20:32:25 +0300
Message-ID: <20161022173231.170417-1-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga14.intel.com ([192.55.52.115]:58921 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S964850AbcJVRcg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 22 Oct 2016 13:32:36 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Just collection of clean ups against SCSI drivers. Some of them were Acked
quite long ago, but didn't make upstream yet.

Andy Shevchenko (5):
  scsi: fnic: use kernel's '%pM' format option to print MAC
  fusion: print lan address via %pMR
  [SCSI] ips: don't use custom hex_asc_upper[] table
  scsi: replace custom approach to hexdump small buffers
  cciss: replace custom function to hexdump

Oleksandr Khoshaba (1):
  scsi: qla4xxx: print MAC and SID via %p[mM][R]

 drivers/block/cciss_scsi.c        | 72 ++++++---------------------------------
 drivers/message/fusion/mptbase.c  | 14 +++-----
 drivers/scsi/fnic/vnic_dev.c      | 10 ++----
 drivers/scsi/ips.c                | 13 +++----
 drivers/scsi/qla4xxx/ql4_mbx.c    |  5 +--
 drivers/scsi/qla4xxx/ql4_nx.c     |  8 ++---
 drivers/scsi/qla4xxx/ql4_os.c     | 15 +++-----
 drivers/scsi/scsi_transport_srp.c | 11 +-----
 drivers/scsi/sd.c                 |  4 +--
 9 files changed, 30 insertions(+), 122 deletions(-)

-- 
2.9.3

