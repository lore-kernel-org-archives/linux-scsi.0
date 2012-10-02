From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 0/3] virtio-scsi updates for 3.7
Date: Tue,  2 Oct 2012 17:25:45 +0200
Message-ID: <1349191548-7120-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

James, here is a resend of the three pending patches for
virtio-scsi, with the bugfix first.

Thanks,

Paolo

Paolo Bonzini (2):
  virtio-scsi: fix LUNs greater than 255
  virtio-scsi: support online resizing of disks

Richard W.M. Jones (1):
  virtio-scsi: initialize scatterlist structure

 drivers/scsi/virtio_scsi.c  |   39 ++++++++++++++++++++++++++++++++++++---
 include/linux/virtio_scsi.h |    2 ++
 2 files changed, 38 insertions(+), 3 deletions(-)
