From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/11] hpsa: minor fixes and cleanups
Date: Thu, 07 Nov 2013 10:45:23 -0600
Message-ID: <20131107164258.3504.5892.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g6t0186.atlanta.hp.com ([15.193.32.63]:45776 "EHLO
	g6t0186.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753947Ab3KGQp0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Nov 2013 11:45:26 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

The following series implements some minor fixes and cleanups for hpsa

---

Stephen M. Cameron (11):
      hpsa: use workqueue instead of kernel thread for lockup detection
      hpsa: do not attempt to flush the cache on locked up controllers
      hpsa: add 5 second delay after doorbell reset
      hpsa: do not discard scsi status on aborted commands
      hpsa: remove unneeded include of seq_file.h
      hpsa: fix memory leak in CCISS_BIG_PASSTHRU ioctl
      hpsa: add MSA 2040 to list of external target devices
      hpsa: cap CCISS_PASSTHRU at 20 concurrent commands.
      hpsa: prevent stalled i/o
      hpsa: rename scsi prefetch field
      hpsa: enable unit attention reporting


 drivers/scsi/hpsa.c     |  252 +++++++++++++++++++++++++++--------------------
 drivers/scsi/hpsa.h     |    9 +-
 drivers/scsi/hpsa_cmd.h |    4 +
 3 files changed, 157 insertions(+), 108 deletions(-)

-- 
-- steve
