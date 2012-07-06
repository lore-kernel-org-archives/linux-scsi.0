From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.5-rc6
Date: Fri, 06 Jul 2012 13:57:58 -0700
Message-ID: <1341608278.23954.451.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Rustad, Mark D" <mark.d.rustad@intel.com>, Alan Cox <alan@linux.intel.com>, Chad Dupuis <chad.dupuis@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Please pull the following two minor target fixes for v3.5-rc6 from the
usual location here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

There is really nothing exciting and/or controversial this time around.

There's one fix from MDR for a RCU debug warning message within tcm_fc
code (CC'ed to stable), and a small AC fix for qla_target.c based upon a
recent Coverity static report.

Also, there is one other outstanding virtio-scsi LUN scanning bugfix
that has been uncovered with the in-flight tcm_vhost driver over the
last days, and that needs to make it into 3.5 final too.  This patch has
been posted to linux-scsi again here:

  http://marc.info/?l=linux-scsi&m=134160609212542&w=2

and I've asked James to include it in his next PULL request.

Thank you!

Alan Cox (1):
  qla2xxx: print the right array elements in qlt_async_event

Mark Rustad (1):
  tcm_fc: Resolve suspicious RCU usage warnings

 drivers/scsi/qla2xxx/qla_target.c |   35 ++++++++++++++++++-----------------
 drivers/target/tcm_fc/tfc_sess.c  |    3 ++-
 2 files changed, 20 insertions(+), 18 deletions(-)
