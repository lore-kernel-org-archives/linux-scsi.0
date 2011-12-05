From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH v2 0/2] virtio-scsi driver
Date: Mon,  5 Dec 2011 18:29:17 +0100
Message-ID: <1323106159-6562-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

This is the first implementation of the virtio-scsi driver, a virtual
HBA that will be supported by KVM.  It implements a subset of the spec,
in particular it does not implement asynchronous notifications for either
LUN reset/removal/addition or CD-ROM media events, but it is already
functional and usable.

Other matching bits:

- spec at http://people.redhat.com/pbonzini/virtio-spec.pdf (and just
  sent out)

- QEMU implementation at git://github.com/bonzini/qemu.git,
  branch virtio-scsi (will send it out tomorrow)

Please review.  It would be great if this could make it into 3.3.

Paolo Bonzini (2):
  virtio-scsi: first version
  virtio-scsi: add error handling

 drivers/scsi/Kconfig        |    8 +
 drivers/scsi/Makefile       |    1 +
 drivers/scsi/virtio_scsi.c  |  551 ++++++++++++++++++++++++++++++++++++++++++++
 include/linux/virtio_scsi.h |  112 +++++++++++
 include/linux/virtio_ids.h  |    1 +
 4 files changed, 673 insertions(+), 0 deletions(-)
 create mode 100644 drivers/scsi/virtio_scsi.c

-- 
1.7.7.1
