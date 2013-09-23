From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/10] hpsa: September 2013 driver fixes
Date: Mon, 23 Sep 2013 13:33:25 -0500
Message-ID: <20130923183128.19995.7669.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:47511 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866Ab3IWSd1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Sep 2013 14:33:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

The following series contains some fixes for hpsa 

---

Stephen M. Cameron (10):
      hpsa: do not attempt to flush the cache on locked up controllers
      hpsa: add 5 second delay after doorbell reset
      hpsa: do not discard scsi status on aborted commands
      hpsa: remove unneeded include of seq_file.h
      hpsa: fix memory leak in CCISS_BIG_PASSTHRU ioctl
      hpsa: add MSA 2040 to list of external target devices
      hpsa: hide logical drives with format in progress from linux
      hpsa: bring logical drives online when format completes
      hpsa: cap CCISS_PASSTHRU at 20 concurrent commands.
      hpsa: prevent stalled i/o


 drivers/scsi/hpsa.c |  308 +++++++++++++++++++++++++++++++++++++++++++++++----
 drivers/scsi/hpsa.h |   20 +++
 2 files changed, 305 insertions(+), 23 deletions(-)

-- 
-- steve
