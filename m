From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.7.0
Date: Thu, 29 Nov 2012 11:09:45 -0800
Message-ID: <1354216185.25770.25.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

So just a single target fix for v3.7.0 this time around from Roland to
address a aborted command bug w/ tcm_qla2xxx fabric ports.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Also, there is one outstanding IBLOCK + virtio-blk bug that is still
being tracked down effecting v3.6.x, but AFAICT thus far this appears to
be a bug outside of target code.

Thank you,

--nab

Roland Dreier (1):
  target: Fix handling of aborted commands

 drivers/target/target_core_transport.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)
