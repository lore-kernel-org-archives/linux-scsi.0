From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Mon, 16 Dec 2013 07:10:19 -0800
Message-ID: <1387206619.2200.6.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33477 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754448Ab3LPPKV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>

This set should fix our target problems with USB by making the target
visibility properly reference counted.  Since it's a major change to the
infrastructure, we'll incubate upstream first before backporting to
stable.

James

---

James Bottomley (2):
  [SCSI] fix our current target reap infrastructure.
  [SCSI] dual scan thread bug fix

 drivers/scsi/scsi_scan.c   | 102 ++++++++++++++++++++++++++++-----------------
 drivers/scsi/scsi_sysfs.c  |  15 ++++---
 include/scsi/scsi_device.h |   3 +-
 3 files changed, 74 insertions(+), 46 deletions(-)


