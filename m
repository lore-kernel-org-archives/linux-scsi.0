From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/5] ZBC support clenaup and fixes
Date: Wed, 11 Oct 2017 05:54:20 +0900
Message-ID: <20171010205425.7376-1-damien.lemoal@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55567 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933196AbdJJUy0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Oct 2017 16:54:26 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>

Martin,

First part of the "scsi-mq support for ZBC disks" series that is only scsi
specific. These patches are just cleanups with only one bug fix (last pacth)
and do not functionally change anything.

The remaining rework of the zone locking including scsi-mq support is still
ongoing and will be sent later.

Please consider these for addition to 4.15.

Damien Le Moal (5):
  scsi: sd_zbc: Move ZBC declarations to scsi_proto.h
  scsi: sd_zbc: Fix comments and indentation
  scsi: sd_zbc: Rearrange code
  scsi: sd_zbc: Use well defined macros
  scsi: sd_zbc: Fix sd_zbc_read_zoned_characteristics()

 drivers/scsi/scsi_lib.c   |   5 +-
 drivers/scsi/sd_zbc.c     | 169 ++++++++++++++++++++++++++++++----------------
 include/scsi/scsi_proto.h |  45 +++++++++---
 3 files changed, 150 insertions(+), 69 deletions(-)

-- 
2.13.6
