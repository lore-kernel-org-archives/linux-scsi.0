From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V4 00/24] aacraid: Patchset for Smart Family Support
Date: Thu, 2 Feb 2017 15:53:14 -0800
Message-ID: <20170202235338.14724-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0059.outbound.protection.outlook.com ([104.47.34.59]:58080
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751512AbdBCGao (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 3 Feb 2017 01:30:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de

This patchset adds support to the HBA1000 and SMARTIOC2000
family of cards. The driver version is now updated to 50740

Changes in V2:
Fixed kbuild test robot warnings

Changes in V3:
Removed Camel case definitions
Misc fixes

Changes in V4:
Removed Camel case defintions
Misc fixes
Reworked functions to make them understandable
Removed unecessary indendation levels

Raghava Aditya Renukunta (24):
  [SCSI] aacraid: Remove duplicate irq management code
  [SCSI] aacraid: Added aacraid.h include guard
  [SCSI] aacraid: Added support for init_struct_8
  [SCSI] aacraid: Added sa firmware support
  [SCSI] aacraid: Retrieve and update the device types
  [SCSI] aacraid: Reworked scsi command submission path
  [SCSI] aacraid: Process Error for response I/O
  [SCSI] aacraid: Added support for response path
  [SCSI] aacraid: Added support for read medium error
  [SCSI] aacraid: Reworked aac_command_thread
  [SCSI] aacraid: Added support for periodic wellness sync
  [SCSI] aacraid: Retrieve Queue Depth from Adapter FW
  [SCSI] aacraid: Added support to set QD of attached drives
  [SCSI] aacraid: Added support for hotplug
  [SCSI] aacraid: Include HBA direct interface
  [SCSI] aacraid: Add task management functionality
  [SCSI] aacraid: Added support to abort cmd and reset lun
  [SCSI] aacraid: VPD 83 type3 support
  [SCSI] aacraid: Added new IWBR reset
  [SCSI] aacraid: Added ioctl to trigger IOP/IWBR reset
  [SCSI] aacraid: Retrieve HBA host information ioctl
  [SCSI] aacraid: Update copyrights
  [SCSI] aacraid: Change Driver Version Prefix
  [SCSI] aacraid: Update version

 drivers/scsi/aacraid/aachba.c   | 1289 +++++++++++++++++++++++++++++----------
 drivers/scsi/aacraid/aacraid.h  |  644 ++++++++++++++++---
 drivers/scsi/aacraid/commctrl.c |  342 ++++++++---
 drivers/scsi/aacraid/comminit.c |  330 +++++-----
 drivers/scsi/aacraid/commsup.c  |  964 +++++++++++++++++++++--------
 drivers/scsi/aacraid/dpcsup.c   |  159 +++--
 drivers/scsi/aacraid/linit.c    |  562 +++++++++++------
 drivers/scsi/aacraid/nark.c     |    3 +-
 drivers/scsi/aacraid/rkt.c      |    5 +-
 drivers/scsi/aacraid/rx.c       |   17 +-
 drivers/scsi/aacraid/sa.c       |    9 +-
 drivers/scsi/aacraid/src.c      |  336 +++++++---
 12 files changed, 3453 insertions(+), 1207 deletions(-)

-- 
2.7.4
