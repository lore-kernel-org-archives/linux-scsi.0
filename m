From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V1 0/7] Drivers: hv/scsi: Implement multi-channel support
Date: Thu, 16 May 2013 05:19:44 -0700
Message-ID: <1368706784-32276-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded04.prod.phx3.secureserver.net ([208.109.80.198]:51513
	"EHLO p3plsmtps2ded04.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab3EPLpw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 May 2013 07:45:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org, apw@canonical.com, jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

This patch-set implements multi-channel support for Hyper-V devices. Also
support for synthetic Fiber Channel device is included. The first two
patches in the series are the foundational pieces for many of the remaining
patches.

James, once Greg accepts the first two patches, you can consider the scsi
patches.

In this version, based on Greg's comments, I have fixed the names of the
exported symbols from the vmbus driver.

K. Y. Srinivasan (7):
  Drivers: hv: vmbus: Implement multi-channel support
  Drivers: hv: Add the GUID fot synthetic fiber channel device
  Drivers: scsi: storvsc: Make the scsi timeout a module parameter
  Drivers: scsi: storvsc: Update the storage protocol to win8 level
  Drivers: scsi: storvsc: Implement multi-channel support
  Drivers: scsi: storvsc: Support FC devices
  Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS

 drivers/hv/channel.c       |   41 +++++-
 drivers/hv/channel_mgmt.c  |  116 ++++++++++++++-
 drivers/scsi/storvsc_drv.c |  342 +++++++++++++++++++++++++++++++++++++++-----
 include/linux/hyperv.h     |   70 +++++++++
 4 files changed, 522 insertions(+), 47 deletions(-)

-- 
1.7.4.1

