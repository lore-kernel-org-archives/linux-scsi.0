From: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/5] Drivers: scsi: storvsc
Date: Mon,  3 Jun 2013 16:18:39 -0700
Message-ID: <1370301519-27196-1-git-send-email-kys@microsoft.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:48153
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758766Ab3FCWnh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Jun 2013 18:43:37 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org, ohering@suse.com, jbottomley@parallels.com, hch@infradead.org, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>

This set adds multi-channel support as well synthetic Fibre Channel support
to storvsc. The multi-channel support depends on infrastructure in the VMBUS
driver. Greg has already checked in the relevant patches to VMBUS.

I had posted an earlier version of this patch-set that included the VMBUS
related changes. I have since separated the VMBUS chages and these have already been
checked in.

K. Y. Srinivasan (5):
  Drivers: scsi: storvsc: Make the scsi timeout a module parameter
  Drivers: scsi: storvsc: Update the storage protocol to win8 level
  Drivers: scsi: storvsc: Implement multi-channel support
  Drivers: scsi: storvsc: Support FC devices
  Drivers: scsi: storvsc: Increase the value of STORVSC_MAX_IO_REQUESTS

 drivers/scsi/storvsc_drv.c |  349 +++++++++++++++++++++++++++++++++++++++-----
 1 files changed, 310 insertions(+), 39 deletions(-)

-- 
1.7.4.1

