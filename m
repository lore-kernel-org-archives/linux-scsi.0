From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.0
Date: Fri, 10 Apr 2015 15:04:51 -0700
Message-ID: <1428703491.20502.66.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target fixes for v4.0 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

Just a few small fixes.

Two from Andy, the first addresses a v4.0 target specific regression to
a user visible configfs attribute, and the second adds a set of missing
brackets around IPv6 discovery portal information within iscsi-target.

And one from Mike that fixes an OOPs regression in traditional
iscsi-target when an iovec allocation fails, that has been present since
v3.10.y code.  (CC'd to stable)

Thank you,

--nab

Andy Grover (2):
  target: Allow userspace to write 1 to attrib/emulate_fua_write
  iscsi-target: TargetAddress in SendTargets should bracket ipv6
    addresses

Mike Christie (1):
  iscsi target: fix oops when adding reject pdu

 drivers/target/iscsi/iscsi_target.c | 11 ++++++++---
 drivers/target/target_core_device.c |  4 ++--
 2 files changed, 10 insertions(+), 5 deletions(-)
