From: Manish Rangankar <manish.rangankar@cavium.com>
Subject: [PATCH 0/7]qedi: Bug fixes.
Date: Fri, 19 May 2017 01:33:14 -0700
Message-ID: <20170519083321.18030-1-manish.rangankar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0042.outbound.protection.outlook.com ([104.47.36.42]:27866
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752475AbdESId0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 May 2017 04:33:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, lduncan@suse.com, cleech@redhat.com
Cc: linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com

Martin,

Please apply this patch set to next 'scsi-fixes' series.

Thanks,
Manish

Arun Easi (1):
  qedi: Fix bad pte call trace when iscsiuio is stopped.

Manish Rangankar (5):
  qedi: Correctly set firmware max supported BDs.
  qedi: Set dma_boundary to 0xfff.
  qedi: Fix endpoint NULL panic in qedi_set_path.
  qedi: Set firmware tcp msl timer value.
  qedi: Fix endpoint NULL panic during recovery.

Nilesh Javali (1):
  qedi: set max_fin_rt default value

 drivers/scsi/qedi/qedi.h       |  3 ++-
 drivers/scsi/qedi/qedi_fw.c    |  2 ++
 drivers/scsi/qedi/qedi_iscsi.c |  7 ++++++-
 drivers/scsi/qedi/qedi_main.c  | 25 +++++++++++++------------
 4 files changed, 23 insertions(+), 14 deletions(-)

-- 
1.8.3.1
