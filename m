From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] tcm_vhost: Initial merge of vhost level target fabric
 driver
Date: Mon, 30 Jul 2012 18:19:37 -0700
Message-ID: <1343697577.22538.661.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, kvm-devel <kvm@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>, "Michael S. Tsirkin" <mst@redhat.com>, Stefan Hajnoczi <stefanha@gmail.com>, Anthony Liguori <anthony@codemonkey.ws>, Paolo Bonzini <pbonzini@redhat.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Zhi Yong Wu <wuzhy@cn.ibm.com>, LKML <linux-kernel@vger.kernel.org>, lf-virt <virtualization@lists.linux-foundation.org>, Jens Axboe <axboe@kernel.dk>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here is the PULL request for the initial merge of tcm_vhost based on
RFC-v5 code with MST's ACK appended to the initial merge commit.
As promised, the commit is available from two different branches for you
to consider merging as for-3.6 code.

The 'for-next-merge' branch based on mainline commit 7409a6657ae using
3.5-rc2 code contains two duplicates of pre-merge vhost patch
dependencies that have already been merged into mainline via net-next.
This commit is also in the 07302012 -next patchset, and available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next-merge

Or the 'for-linus' branch containing an -rc0 head @ commit bdc0077af57:

   Merge tag 'scsi-misc' of git://git.kernel.org/../jejb/scsi)

rebased up to the last commit in scsi-misc required for virtio-scsi
client LLD scanning logic to function properly with tcm_vhost fabric
ports, is available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-linus

Both branches have gotten recent testing and have been running
over-night small block random I/O tests connected to raw block flash
backends.  The same diffstat below will result from pulling either
branch.

Also, the incremental patch to address MST's last round of post-merge
comments has been sent to the lists for feedback this afternoon.  This
will be included into the usual post -rc1 PULL via 3.6-rc-fixes, along
with any other bits that end up changing post-merge.

Please let us know if you have any concerns.

Thank you!

--nab

Nicholas Bellinger (1):
  tcm_vhost: Initial merge for vhost level target fabric driver

 drivers/vhost/Kconfig     |    3 +
 drivers/vhost/Kconfig.tcm |    6 +
 drivers/vhost/Makefile    |    2 +
 drivers/vhost/tcm_vhost.c | 1628 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/vhost/tcm_vhost.h |  101 +++
 5 files changed, 1740 insertions(+), 0 deletions(-)
 create mode 100644 drivers/vhost/Kconfig.tcm
 create mode 100644 drivers/vhost/tcm_vhost.c
 create mode 100644 drivers/vhost/tcm_vhost.h
