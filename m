From: Douglas Gilbert <dougg@torque.net>
Subject: [PATCH] lk 2.5.31 scsi_debug version 1.62
Date: Tue, 13 Aug 2002 00:19:47 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3D5888E3.573F5100@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dial1.torque.net [204.138.244.11])
	by gear.torque.net (8.9.3/8.9.3) with ESMTP id AAA04302
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2002 00:19:36 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here is an update for scsi_debug that utilizes driverfs 
support for per driver parameters added in lk 2.5.31

Tarball
  http://www.torque.net/sg/p/scsi_debug_162.tgz
Patch:
  http://www.torque.net/sg/p/scsi_debug_162_lk2531.diff.gz


1.62 changes:
  - driverfs support for these options (more to come):
    /driverfs/bus/scsi/drivers/scsi_debug/delay [rw]
    /driverfs/bus/scsi/drivers/scsi_debug/num_devs [r]
    /driverfs/bus/scsi/drivers/scsi_debug/opts [rw]
  - start using some C99
  - fdisk requires EINVAL from unsupported ioctls
    (scsi_debug previously used ENOTTY)

1.61 changes:
  - simulate delayed responses, controlled by
    'scsi_debug_delay'
  - support REPORT LUNS
  - support more MODE SENSE pages
  - [following Doug Ledford's suggestion] do autosense
    (i.e. set Scsi_Cmnd::sense_buffer array appropriately
     when a status of CHECK CONDITION is set)
  - minor driverfs support
  - start adding error injection logic, see
    "scsi_debug_every_nth"

Doug Gilbert
