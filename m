From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/6] Drivers: hv/scsi: Implement multi-channel support
Date: Wed, 15 May 2013 15:02:00 -0700
Message-ID: <1368655320-27599-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This patch-set implements multi-channel support for Hyper-V devices. Also
support for synthetic Fiber Channel device is included. The first two
patches in the series are the foundational pieces for the remaining patches.

James, once Greg accepts the first two patches, you can consider the scsi
patches.


K. Y. Srinivasan (6):
  Drivers: hv: vmbus: Implement multi-channel support
  Drivers: hv: Add the GUID fot synthetic fiber channel device
  Drivers: scsi: storvsc: Make the scsi timeout a module parameter
  Drivers: scsi: storvsc: Update the storage protocol to win8 level
  Drivers: scsi: storvsc: Implement multi-channel support
  Drivers: scsi: storvsc: Support FC devices

 drivers/hv/channel.c       |   41 +++++-
 drivers/hv/channel_mgmt.c  |  117 +++++++++++++++-
 drivers/scsi/storvsc_drv.c |  340 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/hyperv.h     |   70 +++++++++
 4 files changed, 522 insertions(+), 46 deletions(-)

-- 
1.7.4.1
