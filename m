From: damien.lemoal@wdc.com
Subject: [PATCH 0/9] scsi: sd/sd_zbc cleanup and improvements
Date: Fri, 21 Apr 2017 18:16:40 +0900
Message-ID: <20170421091649.25287-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:48820 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S970415AbdDUJRQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Apr 2017 05:17:16 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

This series of small patches cleanup code mainly in sd.c and sd_zbc.c, with
another small improvement in scsi_error.c.

The first 2 patches are not stricktly necessary but would be great to apply to
make emacs pretty printer happy and reduce its overhead (if white space
highlighting is enabled).

The last patch is the only one that introduces a functional change. All other
patches do not change any functionality.

Comments and reviews are welcome.

Bart Van Assche (1):
  sd_zbc: Remove superfluous assignments

Damien Le Moal (8):
  sd: Remove white space before EOL
  sd: Fix functions description
  sd: Remove unecessary variable in sd_done()
  sd: Improve sd_completed_bytes
  sd: Cleanup sd_done sense data handling
  scsi: Improve scsi_get_sense_info_fld
  sd_zbc: Rename sd_zbc_setup_write_cmnd
  sd_zbc: Do not write lock zones for reset

 drivers/scsi/scsi_error.c |  36 ++---
 drivers/scsi/sd.c         | 402 +++++++++++++++++++++++-----------------------
 drivers/scsi/sd.h         |   8 +-
 drivers/scsi/sd_zbc.c     |  60 +++----
 include/scsi/scsi_eh.h    |   4 +-
 5 files changed, 243 insertions(+), 267 deletions(-)

-- 
2.9.3
