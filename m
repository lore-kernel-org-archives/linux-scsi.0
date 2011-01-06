From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/11] hpsa: updates, January 2011
Date: Thu, 06 Jan 2011 14:47:42 -0600
Message-ID: <20110106204429.10753.92575.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:9161 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753050Ab1AFUrp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2011 15:47:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: linux-scsi@vger.kernel.org, mike.miller@hp.com, linux-kernel@vger.kernel.org, thenzl@redhat.com, akpm@linux-foundation.org, smcameron@yahoo.com

The following series contains a few miscellaneous fixes for hpsa.
The biggest change is to the reset_devices code to fix the
saving/restoring of PCI registers so that the "doorbell"
reset method now works on those controllers which support it.

---

Stephen M. Cameron (11):
      hpsa: defend against zero sized buffers in passthru ioctls
      hpsa: fixup DMA address before freeing.
      hpsa: Remove duplicate defines of DIRECT_LOOKUP_ constants
      hpsa: fix board status waiting code
      hpsa: Use kernel provided PCI state save and restore functions
      hpsa: limit commands allocated on reset_devices
      hpsa: do not reset unknown boards on reset_devices
      hpsa: take the adapter lock in hpsa_wait_for_mode_change_ack
      hpsa: allow driver to put controller in either simple or performant mode
      hpsa: use usleep_range not msleep for small sleeps
      hpsa: Add a per controller commands_outstanding entry in /sys


 Documentation/scsi/hpsa.txt |    6 +
 drivers/scsi/hpsa.c         |  210 ++++++++++++++++++++++---------------------
 drivers/scsi/hpsa.h         |    4 +
 drivers/scsi/hpsa_cmd.h     |    1 
 4 files changed, 119 insertions(+), 102 deletions(-)

-- 
-- steve
