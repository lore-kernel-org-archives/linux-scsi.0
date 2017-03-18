From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 0/3] SCSI ALUA device handler bug fixes
Date: Fri, 17 Mar 2017 17:02:00 -0700
Message-ID: <20170318000203.7469-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:46496 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdCRAIH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2017 20:08:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>

Hello Martin,

These three patches are what I came up with while I was chasing a
scsi_device_put() crash. Please consider these for inclusion in the
upstream kernel.

Thanks,

Bart.

Bart Van Assche (3):
  scsi_dh_alua: Check scsi_device_get() return value
  scsi_dh_alua: Ensure that alua_activate() calls the completion
    function
  scsi_dh_alua: Warn if the first argument of alua_rtpg_queue() is NULL

 drivers/scsi/device_handler/scsi_dh_alua.c | 38 +++++++++++++++++++-----------
 1 file changed, 24 insertions(+), 14 deletions(-)

-- 
2.12.0
