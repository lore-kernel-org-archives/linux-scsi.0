From: Bart Van Assche <bart.vanassche@wdc.com>
Subject: [PATCH 0/3] SCSI device blacklist handling improvements
Date: Mon,  4 Dec 2017 10:36:30 -0800
Message-ID: <20171204183633.32139-1-bart.vanassche@wdc.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:31911 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751934AbdLDSge (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Dec 2017 13:36:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@wdc.com>

Hello Martin,

These three patches is what I came up with after having reviewed recent
changes in the code for handling blacklist flags handling. Please consider
these patches for kernel v4.16.

Note: since patch "Use 'blist_flags_t' for scsi_devinfo flags" is not yet
in the 4.16/scsi-queue branch I have developed these patches on top of a
merge of the v4.15-rc1 release and your 4.16/scsi-queue branch.

Thanks,

Bart.

Bart Van Assche (3):
  scsi_get_device_flags_keyed(): Always return device flags
  Use blist_flags_t consistently
  Introduce scsi_devinfo_key enumeration type

 drivers/scsi/scsi_devinfo.c       | 29 ++++++++++++-----------------
 drivers/scsi/scsi_priv.h          | 14 ++++++++------
 drivers/scsi/scsi_scan.c          | 13 +++++++------
 drivers/scsi/scsi_sysfs.c         |  4 ++--
 drivers/scsi/scsi_transport_spi.c | 12 +++++++-----
 5 files changed, 36 insertions(+), 36 deletions(-)

-- 
2.15.0
