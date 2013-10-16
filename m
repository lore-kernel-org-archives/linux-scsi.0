From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/5] Updates for tcm_loop
Date: Wed, 16 Oct 2013 09:12:51 +0200
Message-ID: <1381907576-81857-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48355 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758281Ab3JPHNB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Oct 2013 03:13:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Nic Bellinger <nab@daterainc.com>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi Nic,

here are some updates to tcm_loop I've done during ALUA testing.
I've implemented a 'transport_state' attribute to simulate
transport failure and added command abort callbacks.

Hannes Reinecke (5):
  tcm_loop: Check for valid hba in tcm_loop_drop_nexus()
  tcm_loop: Implement transport offline
  tcm_loop: separate out tcm_loop_issue_tmr
  tcm_loop: TCQ and command abort support
  tcm_loop: Implement target reset

 drivers/target/loopback/tcm_loop.c | 233 +++++++++++++++++++++++++++++++------
 drivers/target/loopback/tcm_loop.h |   6 +
 include/target/target_core_base.h  |   1 +
 3 files changed, 204 insertions(+), 36 deletions(-)

-- 
1.7.12.4

