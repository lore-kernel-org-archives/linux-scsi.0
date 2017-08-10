From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH v2 0/2] virtio_scsi: Set can_queue based on size of virtqueue.
Date: Thu, 10 Aug 2017 17:56:50 +0100
Message-ID: <20170810165652.21515-1-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, mst@redhat.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

v1 was here:

  https://lkml.org/lkml/2017/8/10/689

v1 -> v2:

  Remove .can_queue field from the templates.

Rich.
