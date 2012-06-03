From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target 3.5-merge fixes for -rc2
Date: Sun, 03 Jun 2012 12:39:32 -0700
Message-ID: <1338752372.4238.24.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are two target patches currently in the queue for 3.5-rc2.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.5-merge-fixes

The first is a small name-space collision fix from Stefan for the new
sbp-target / ieee-1394 code, and second is the FILEIO backend conversion
patch to always use O_DSYNC by default instead of O_SYNC as recommended
by hch.  Note the latter is CC'ed stable.

This branch is based upon commit:

commit af56e0aa35f3ae2a4c1a6d1000702df1dd78cb76
Merge: 65a50c9 6bd9adb
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed May 30 11:17:19 2012 -0700

    Merge git://git.kernel.org/pub/scm/linux/kernel/git/sage/ceph-client

Please let us know if you have any concerns.

Thanks!

--nab

Nicholas Bellinger (1):
  target/file: Use O_DSYNC by default for FILEIO backends

Stefan Richter (1):
  sbp-target: rename a variable to avoid name clash

 drivers/target/sbp/sbp_target.c   |    8 ++--
 drivers/target/target_core_file.c |   70 +++++++++----------------------------
 drivers/target/target_core_file.h |    1 -
 3 files changed, 21 insertions(+), 58 deletions(-)
