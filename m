From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [GIT PULL] exofs: 3 changes to exofs & osd
Date: Mon, 17 Dec 2012 18:53:21 +0200
Message-ID: <50CF4E01.5030004@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from natasha.panasas.com ([67.152.220.90]:35798 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149Ab2LQQxm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2012 11:53:42 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, open-osd <osd-dev@open-osd.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

Hi Linus.

Please pull the following changes since commit [ddffeb8c] Linux 3.7-rc1
They are available in the git repository at:

  git://git.open-osd.org/linux-open-osd.git for-linus

for you to fetch changes up to
	[861d6660] exofs: don't leak io_state and pages on read error (2012-12-14 12:17:32 +0200)

These are just 3 patches, the last two are bug fixes on the error paths
in exofs.

The important patch is the one to osd_uld which adds sysfs info to osd
devices for use by user-mode clustering discovery software. I'm already
sitting on this patch since before February this year, It is important for
some of the big installation cluster systems, who's been compiling their
own kernel just for that patch.

Thanks in advance
Boaz

----------------------------------------------------------------
Boaz Harrosh (1):
      exofs: don't leak io_state and pages on read error

Idan Kedar (1):
      exofs: clean up the correct page collection on write error

Sachin Bhamare (1):
      osduld: Add osdname & systemid sysfs at scsi_osd class

 drivers/scsi/osd/osd_uld.c | 28 ++++++++++++++++++++++++++++
 fs/exofs/inode.c           | 16 +++++++++-------
 2 files changed, 37 insertions(+), 7 deletions(-)
