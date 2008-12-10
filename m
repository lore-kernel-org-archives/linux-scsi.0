From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH][RFC 8/23]: SCST pass-through backend handlers
Date: Wed, 10 Dec 2008 21:42:11 +0300
Message-ID: <49400D83.4060502@vlnb.net>
References: <494009D7.4020602@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.186]:59013 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963AbYLJSmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Dec 2008 13:42:23 -0500
In-Reply-To: <494009D7.4020602@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Jeff Garzik <jeff@garzik.org>, Boaz Harrosh <bharrosh@panasas.com>, Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Bart Van Assche <bart.vanassche@gmail.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

This patch contains SCST pass-through backend dev handlers. There are 
handlers for disks (type 0), tapes (type 1), processors (type 3), CDROMs 
(type 5), MO disks (type 7), medium changers (type 8) and RAID 
controllers (type 0xC).

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
  drivers/scst/dev_handlers/scst_cdrom.c       |  299 +++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_changer.c     |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_dev_handler.h |  113 ++++++++++++++
  drivers/scst/dev_handlers/scst_disk.c        |  384 +++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_modisk.c      |  406 ++++++++++++++++++++++++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_processor.c   |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_raid.c        |  229 ++++++++++++++++++++++++++++
  drivers/scst/dev_handlers/scst_tape.c        |  426 +++++++++++++++++++++++++++++++++++++++++++++++++++++
  8 files changed, 2315 insertions(+)

The patch is too big to be submitted inline. You can find it in 
http://scst.sourceforge.net/patches/scst_passthrough.diff



