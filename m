From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] target: Sparse bugfixes and warnings/annotations
Date: Mon, 24 Jan 2011 12:37:23 -0800
Message-ID: <1295901446-17089-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp109.sbc.mail.mud.yahoo.com ([68.142.198.205]:24251 "HELO
	smtp109.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750712Ab1AXUhM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jan 2011 15:37:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Fubo Chen <fubo.chen@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings folks,

This series is a breakout of Fubo's recent sparse patches.  The first
two patches fix real potential deadlocks for sanity check failures in
target_core_device.c, and the third contains the various non-critical
changes and locking annotations.

Thanks again to Fubo for his contribution!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Fubo Chen (3):
  target: Drop nacl->device_list_lock on
    core_update_device_list_for_node failure
  target: Reaquire hba_lock + se_port_lock during se_clear_dev_ports
    continue
  target: Minor sparse warning fixes and annotations

 drivers/target/target_core_device.c     |    5 +++++
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_mib.c        |   20 ++++++++++++++++++++
 drivers/target/target_core_pscsi.c      |    3 +++
 drivers/target/target_core_rd.h         |    2 --
 drivers/target/target_core_transport.c  |    4 +---
 include/target/target_core_base.h       |   22 +++++++++++-----------
 include/target/target_core_transport.h  |    4 ++++
 8 files changed, 45 insertions(+), 16 deletions(-)

