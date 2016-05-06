From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v1 0/4] scsi: some (very) old clean ups
Date: Fri,  6 May 2016 19:23:55 +0300
Message-ID: <1462551839-44380-1-git-send-email-andriy.shevchenko@linux.intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751418AbcEFQYE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2016 12:24:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

This is a set of independent clean ups that didn't land upstream for ages (some
are dated 2010!).  As agreed with Martin at some point I resend
them.

I have more, but the rest is not yet ready for submission.

Andy Shevchenko (3):
  libsas: remove private hex2bin() implementation
  scsi: fnic: use kernel's '%pM' format option to print MAC
  fusion: print lan address via %pMR

Oleksandr Khoshaba (1):
  scsi: qla4xxx: print MAC and SID via %p[mM][R]

 drivers/message/fusion/mptbase.c    | 14 ++++----------
 drivers/scsi/fnic/vnic_dev.c        | 10 ++--------
 drivers/scsi/libsas/sas_scsi_host.c | 22 ++++++----------------
 drivers/scsi/qla4xxx/ql4_mbx.c      |  5 +----
 drivers/scsi/qla4xxx/ql4_nx.c       |  8 ++------
 drivers/scsi/qla4xxx/ql4_os.c       | 15 ++++-----------
 6 files changed, 19 insertions(+), 55 deletions(-)

-- 
2.8.1

