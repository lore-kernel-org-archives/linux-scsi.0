From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 0/9] hpsa: resend of November 2013 patches
Date: Wed, 04 Dec 2013 17:09:45 -0600
Message-ID: <20131204230123.21798.93593.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0015.houston.hp.com ([15.201.24.18]:4748 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170Ab3LDXJs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Dec 2013 18:09:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: stephenmcameron@gmail.com, mikem@beardog.cce.hp.com, thenzl@redhat.com, linux-scsi@vger.kernel.org, scott.teel@hp.com

This updated series applies on top of the "misc" branch of
git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git

Note: the first two patches in this series revert previously
applied patches which I had not previously realized were present
in James's tree.

There's one extra patch in this set that wasn't present in the series
I sent in November to allow the SCSI mid layer to handle unit attn's.

Patches from the November series that are already present in James's
tree are not in this patch series.

And, finally if this is all too confusing and you want me to send
something else, let me know.

---

Matt Gates (1):
      hpsa: allow SCSI mid layer to handle unit attention

Stephen M. Cameron (8):
      hpsa: revert bring logical drives online when format completes
      hpsa: revert hide logical drives with format in progress from linux
      hpsa: return 0 from driver probe function on success, not 1
      hpsa: use workqueue instead of kernel thread for lockup detection
      hpsa: rename scsi prefetch field
      hpsa: enable unit attention reporting
      hpsa: do not discard scsi status on aborted commands
      hpsa: do not require board "not ready" status after hard reset


 drivers/scsi/hpsa.c     |  321 ++++++-----------------------------------------
 drivers/scsi/hpsa.h     |   17 --
 drivers/scsi/hpsa_cmd.h |    4 -
 3 files changed, 45 insertions(+), 297 deletions(-)

-- 

-- steve

