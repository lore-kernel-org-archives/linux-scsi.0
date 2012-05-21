From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] usb-gadget target merge for 3.5-rc1
Date: Mon, 21 May 2012 16:08:37 -0700
Message-ID: <1337641717.32217.810.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:43804 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586Ab2EUXIk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 May 2012 19:08:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-usb <linux-usb@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Felipe Balbi <balbi@ti.com>, Greg KH <gregkh@linuxfoundation.org>, Alan Stern <stern@rowland.harvard.edu>, Christoph Hellwig <hch@lst.de>

Hi Linus,

As promised, here is the pull request for Sebastian's usb-gadget target
UASP / BOT driver for v3.5-rc1.  This code has been in linux-next for a
number of weeks, and is now ready for an initial merge.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git usb-target-merge

This fabric uses the target framework to provide a usb gadget
device.  This gadget supports the USB Attached SCSI Protocol (UASP)
and Bulk Only Transfers (BOT or BBB). BOT is the primary interface,
UAS is the alternative interface.

Note this series is dependent upon a single target core patch for adding
se_cmd->unknown_data_length in target-pending/for-next, that went out in
the first pull request yesterday:

[GIT PULL] target for-next v3.5-rc1 updates + new drivers merge status
http://www.spinics.net/lists/target-devel/msg02529.html

Kudos to Sebastian for making this driver happen so easily, and for his
patches to improve usb-core and target core along the way to his goal.
Also thanks to Felipe + Greg-KH for their help in getting this driver
ready for mainline.

Thanks!

--nab

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Acked-by: Felipe Balbi <balbi@ti.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Greg KH <gregkh@linuxfoundation.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>

Sebastian Andrzej Siewior (1):
  usb-gadget: Initial merge of target module for UASP + BOT

 drivers/usb/gadget/Kconfig          |   10 +
 drivers/usb/gadget/Makefile         |    2 +
 drivers/usb/gadget/tcm_usb_gadget.c | 2480 +++++++++++++++++++++++++++++++++++
 drivers/usb/gadget/tcm_usb_gadget.h |  146 ++
 4 files changed, 2638 insertions(+), 0 deletions(-)
 create mode 100644 drivers/usb/gadget/tcm_usb_gadget.c
 create mode 100644 drivers/usb/gadget/tcm_usb_gadget.h


