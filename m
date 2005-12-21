From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [GIT PATCH] SCSI bug fixes for 2.6.15-rc6
Date: Wed, 21 Dec 2005 16:54:26 -0600
Message-ID: <1135205667.3533.79.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:46991 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964913AbVLUWyq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Dec 2005 17:54:46 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

Hopefully these are the final two bug fixes before 2.6.15 (hint, hurry
up!).

The update is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

James Bottomley:
  o fix scsi_reap_target() device_del from atomic context

James Smart:
  o fix for fc transport recursion problem

And the diffstat:

 drivers/scsi/scsi_scan.c         |   48 +++++++++++++++++++++++++------
 drivers/scsi/scsi_transport_fc.c |   59 ++++++++++++++++++++++++++++++++++++---
 include/scsi/scsi_transport_fc.h |   11 +++++++
 3 files changed, 104 insertions(+), 14 deletions(-)

James


