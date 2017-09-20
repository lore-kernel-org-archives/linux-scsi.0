From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/2] scsi_dh: suppress errors from unsupported devices
Date: Wed, 20 Sep 2017 09:18:50 +0200
Message-ID: <1505891932-49215-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56016 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751575AbdITHS6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 20 Sep 2017 03:18:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

From: Hannes Reinecke <hare@suse.com>

Hi all,

here's a small patchset to suppress errors from scsi_dh_attach() for
unsupported devices.

As usual, comments and reviews are welcome.

Hannes Reinecke (2):
  scsi_dh: Return SCSI_DH_XX error code from ->attach()
  scsi_dh: suppress errors from unsupported devices

 drivers/scsi/device_handler/scsi_dh_alua.c  | 10 ++++----
 drivers/scsi/device_handler/scsi_dh_emc.c   |  6 ++---
 drivers/scsi/device_handler/scsi_dh_hp_sw.c | 12 ++++++----
 drivers/scsi/device_handler/scsi_dh_rdac.c  |  6 ++---
 drivers/scsi/scsi_dh.c                      | 36 +++++++++++++++++++++--------
 drivers/scsi/scsi_priv.h                    |  4 ++--
 drivers/scsi/scsi_sysfs.c                   |  8 +------
 7 files changed, 48 insertions(+), 34 deletions(-)

-- 
2.12.3
