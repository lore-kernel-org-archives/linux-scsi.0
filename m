From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 0/2] virtio-scsi: Implement FC_HOST feature
Date: Tue, 17 Jan 2017 00:04:28 +0800
Message-ID: <20170116160430.11815-1-famz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Paolo Bonzini <pbonzini@redhat.com>, famz@redhat.com, linux-scsi@vger.kernel.org, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, stefanha@redhat.com, virtualization@lists.linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

This series implements the proposed fc_host feature of virtio-scsi.

The first patch updates the data structure changes according to the spec
proposal; the second patch actually implements the operations.

Fam Zheng (2):
  virtio_scsi: Add fc_host definitions
  virtio_scsi: Implement fc_host

 drivers/scsi/virtio_scsi.c       | 55 +++++++++++++++++++++++++++++++++++++++-
 include/uapi/linux/virtio_scsi.h |  6 +++++
 2 files changed, 60 insertions(+), 1 deletion(-)

-- 
2.9.3
