From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH resend 0/6] virtio-scsi patches for 3.16 + a midlayer one-liner
Date: Tue,  3 Jun 2014 21:33:12 +0200
Message-ID: <1401823998-29167-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: hch@lst.de, JBottomley@Parallels.com, venkateshs@google.com
List-Id: linux-scsi@vger.kernel.org

Sorry for the delay, mostly caused by the discussion and testing of
patch 5.  That's the most important of the bunch, and debugging the
problem also led to the discovery of a midlayer bug fixed by patch 4.

I hope these can make their way into 3.16.  Thanks!

resend: forgot linux-scsi. :(

Paolo


Ming Lei (2):
  virtio_scsi: remove ACCESS_ONCE() and smp_read_barrier_depends()
  virtio-scsi: replace target spinlock with seqcount

Paolo Bonzini (2):
  virtio-scsi: avoid cancelling uninitialized work items
  virtio-scsi: fix various bad behavior on aborted requests

Ulrich Obergfell (1):
  scsi_error: fix invalid setting of host byte

Venkatesh Srinivas (1):
  virtio-scsi: Implement change_queue_depth for virtscsi targets

 drivers/scsi/scsi_error.c  |   2 +-
 drivers/scsi/virtio_scsi.c | 148 +++++++++++++++++++++++++++------------------
 2 files changed, 91 insertions(+), 59 deletions(-)

-- 
1.8.3.1
