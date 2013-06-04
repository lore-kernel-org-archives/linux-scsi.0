From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V3 0/5] Drivers: scsi: storvsc
Date: Tue,  4 Jun 2013 12:04:34 -0700
Message-ID: <1370372674-10046-1-git-send-email-kys@microsoft.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
List-Id: linux-scsi@vger.kernel.org

This set adds multi-channel support as well synthetic Fibre Channel support
to storvsc. The multi-channel support depends on infrastructure in the VMBUS
driver. Greg has already checked in the relevant patches to VMBUS.

I had posted an earlier version of this patch-set that included the VMBUS
related changes. I have since separated the VMBUS chages and these have already been
checked in.

In this version, based on comments from James, the timeout is no longer a module
parameter.

K. Y. Srinivasan (5):
  Drivers: scsi: storvsc: Increase the value of scsi timeout for
    storvsc devices
  Drivers: scsi: storvsc: Update the storage protocol to win8 level
  Drivers: scsi: storvsc: Implement multi-channel support
  Drivers: scsi: storvsc: Support FC devices
  Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS

 drivers/scsi/storvsc_drv.c |  347 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 308 insertions(+), 39 deletions(-)

-- 
1.7.4.1
