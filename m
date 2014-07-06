From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/2] virtio-scsi queue for 3.17
Date: Sun,  6 Jul 2014 16:39:25 +0200
Message-ID: <1404657567-17133-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph asked me to rebase the two virtio-scsi patches from
http://thread.gmane.org/gmane.linux.kernel/1717796 that do not apply
anymore, patch 2 and 6.

These are on top of his drivers-for-3.16 branch, more precisely commit
8faeb529b2da (virtio-scsi: fix various bad behavior on aborted requests).

Paolo

Ming Lei (1):
  virtio-scsi: replace target spinlock with seqcount

Venkatesh Srinivas (1):
  virtio-scsi: Implement change_queue_depth for virtscsi targets

 drivers/scsi/virtio_scsi.c | 75 ++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 62 insertions(+), 13 deletions(-)

-- 
1.8.3.1
