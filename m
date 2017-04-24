From: damien.lemoal@wdc.com
Subject: [PATCH v2 0/7] scsi: sd/sd_zbc cleanup and improvements
Date: Mon, 24 Apr 2017 16:51:08 +0900
Message-ID: <20170424075115.30337-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:15751 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1166215AbdDXHva (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Apr 2017 03:51:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Bart Van Assche <Bart.VanAssche@sandisk.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Damien Le Moal <damien.lemoal@wdc.com>

From: Damien Le Moal <damien.lemoal@wdc.com>

This series of small patches cleanup code mainly in sd.c and sd_zbc.c, with
another small improvement in scsi_error.c.

Only the last patch of this series introduces a functional change. All other
patches do not change any functionality.

Changes from v1:
* Dropped white space patch and white space changes in other patches as
  requested by Bart.
* Dropped patch changing handling of sense_valid in sd_done() as requested by
  James.
* Fixed patch 4 (function declaration) to remove checkscript warnings

Bart Van Assche (1):
  sd_zbc: Remove superfluous assignments

Damien Le Moal (6):
  sd: Fix functions description
  sd: Improve sd_completed_bytes
  sd: Cleanup sd_done sense data handling
  scsi: Improve scsi_get_sense_info_fld
  sd_zbc: Rename sd_zbc_setup_write_cmnd
  sd_zbc: Do not write lock zones for reset

 drivers/scsi/scsi_error.c | 38 ++++++++-----------
 drivers/scsi/sd.c         | 97 ++++++++++++++++++++++++-----------------------
 drivers/scsi/sd.h         |  8 ++--
 drivers/scsi/sd_zbc.c     | 60 +++++++++++------------------
 include/scsi/scsi_eh.h    |  4 +-
 5 files changed, 93 insertions(+), 114 deletions(-)

-- 
2.9.3
