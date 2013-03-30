From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.9-rc5
Date: Sat, 30 Mar 2013 12:43:15 -0700
Message-ID: <1364672595.10253.161.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>, Asias He <asias@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are two more target-pending fixes for v3.9-rc5 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes the bug-fix for a >= v3.8-rc1 regression specific to
iscsi-target persistent reservation conflict handling (CC'ed to stable),
and a tcm_vhost patch to drop VIRTIO_RING_F_EVENT_IDX usage so that
in-flight qemu vhost-scsi-pci device code can detect the proper vhost
feature bits.

Also, there are two more tcm_vhost patches still being discussed by MST
and Asias for v3.9 that will be required for the in-flight qemu
vhost-scsi-pci device patch to function properly, and that should
(hopefully) be the last target fixes for this round.

Thank you,

--nab

Nicholas Bellinger (2):
  tcm_vhost: Avoid VIRTIO_RING_F_EVENT_IDX feature bit
  target: Fix RESERVATION_CONFLICT status regression for iscsi-target
    special case

 drivers/target/target_core_transport.c |    4 +++-
 drivers/vhost/tcm_vhost.c              |   13 +++++++++++--
 2 files changed, 14 insertions(+), 3 deletions(-)
