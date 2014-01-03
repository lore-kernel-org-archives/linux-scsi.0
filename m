From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Thu, 02 Jan 2014 16:36:02 -0800
Message-ID: <1388709362.2399.31.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38724 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751136AbaACAgD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2014 19:36:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, USB list <linux-usb@vger.kernel.org>

This set should fix our target problems with USB by making the target
visibility properly reference counted.  Since it's a major change to the
infrastructure, we'll incubate upstream first before backporting to
stable.

James Bottomley (2):
  [SCSI] fix our current target reap infrastructure.
  [SCSI] dual scan thread bug fix

 drivers/scsi/scsi_scan.c   | 108 +++++++++++++++++++++++++++++----------------
 drivers/scsi/scsi_sysfs.c  |  20 ++++++---
 include/scsi/scsi_device.h |   3 +-
 3 files changed, 84 insertions(+), 47 deletions(-)

James

