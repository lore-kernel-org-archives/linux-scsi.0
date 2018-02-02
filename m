From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI postmerge updates for the 4.15+ merge window
Date: Fri, 02 Feb 2018 19:17:12 +0100
Message-ID: <1517595432.3137.24.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:50094 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753039AbeBBSRR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Feb 2018 13:17:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

This is a set of three patches that depended on mq and zone changes in
the block tree (now upstream).

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-postmerge

The short changelog is:

Bart Van Assche (1):
      scsi: scsi-mq-debugfs: Show more information

Damien Le Moal (2):
      scsi: sd: Remove zone write locking
      scsi: sd_zbc: Initialize device request queue zoned data

And the diffstat:

 drivers/scsi/scsi_debugfs.c |  40 +++++++-
 drivers/scsi/sd.c           |  41 +-------
 drivers/scsi/sd.h           |  11 ---
 drivers/scsi/sd_zbc.c       | 235 +++++++++++++++++++++++++++-----------------
 include/scsi/scsi_cmnd.h    |   3 +-
 5 files changed, 187 insertions(+), 143 deletions(-)

James
