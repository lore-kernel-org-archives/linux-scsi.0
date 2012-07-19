From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.5
Date: Wed, 18 Jul 2012 18:01:33 -0700
Message-ID: <1342659693.18004.747.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Rustad, Mark D" <mark.d.rustad@intel.com>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the last handful of target fixes that have come in recently
that are headed for-3.5 final.  Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes a bugfix from MDR to address a NULL pointer OOPs with FCoE
aborts, along with a WRITE_SAME emulation bugfix for NOLB=0 cases +
persistent reservation return cleanups from Roland.

All three patches are CC'ed to stable.

Thank you!

--nab

Mark Rustad (1):
  tcm_fc: Fix crash seen with aborts and large reads

Roland Dreier (2):
  target: Clean up returning errors in PR handling code
  target: Fix range calculation in WRITE SAME emulation when num blocks
    == 0

 drivers/target/target_core_cdb.c |    2 +-
 drivers/target/target_core_pr.c  |    7 ++++---
 drivers/target/tcm_fc/tfc_cmd.c  |    2 ++
 3 files changed, 7 insertions(+), 4 deletions(-)
