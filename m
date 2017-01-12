From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 0/2] sd fixes for zoned block devices
Date: Thu, 12 Jan 2017 15:25:09 +0900
Message-ID: <20170112062511.20261-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:13341 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750707AbdALGZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jan 2017 01:25:24 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Shaun Tancheff <shaun@tancheff.com>, Hannes Reinecke <hare@suse.de>, Damien Le Moal <damien.lemoal@wdc.com>

2 small fixes in this series:
(1) Fix sd_read_cache_type so that DPOFUA is not disabled for zoned block
devices supporting it.
(2) Ignore the zoned field of the block device characteristics page for
host-managed zoned block devices as there is no good match defined explicitely
for HM by the standard.

Damien Le Moal (2):
  sd: Fix wrong DPOFUA disable in sd_read_cache_type
  sd: Ignore zoned field for host-managed devices

 drivers/scsi/sd.c | 23 ++++++++++++++++-------
 1 file changed, 16 insertions(+), 7 deletions(-)

-- 
2.9.3

