From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.17-rc3
Date: Sun, 31 Aug 2014 11:59:46 -0700
Message-ID: <1409511586.1483.5.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target pending updates for v3.17-rc3.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note that these patches where originally intended for -rc1, but missed
the merge window.  They are mostly iser-target related bug-fixes, along
with a few other very minor cleanups.

Thank you,

--nab

Andreea-Cristina Bernat (1):
  tcm_fc: Replace rcu_assign_pointer() with RCU_INIT_POINTER()

Himangi Saraogi (1):
  target/configfs: Remove unnecessary null test

Nicholas Bellinger (1):
  iscsi-target: Ignore ICF_GOT_LAST_DATAOUT during Data-Out ITT lookup

Rasmus Villemoes (1):
  target: target_core_ua_h: Add #define of include guard

Rickard Strandqvist (1):
  target: target_core_transport.c: Cleaning up missing null-terminate
    in conjunction with strncpy

Sagi Grimberg (4):
  Target/iser: Get isert_conn reference once got to connected_handler
  Target/iser: Don't put isert_conn inside disconnected handler
  Target/iser: Avoid calling rdma_disconnect twice
  Target/iser: Fix initiator_depth and responder_resources

 drivers/infiniband/ulp/isert/ib_isert.c      |   20 +++---
 drivers/target/iscsi/iscsi_target_util.c     |    2 +
 drivers/target/target_core_fabric_configfs.c |    3 +-
 drivers/target/target_core_transport.c       |   86 +++++++++++++-------------
 drivers/target/target_core_ua.h              |    1 +
 drivers/target/tcm_fc/tfc_sess.c             |    2 +-
 6 files changed, 60 insertions(+), 54 deletions(-)
