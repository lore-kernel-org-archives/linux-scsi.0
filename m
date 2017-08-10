From: "Richard W.M. Jones" <rjones@redhat.com>
Subject: [PATCH 0/2] virtio_scsi: Set can_queue based on size of virtqueue.
Date: Thu, 10 Aug 2017 17:40:33 +0100
Message-ID: <20170810164035.19963-1-rjones@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@linux.vnet.ibm.com
Cc: martin.petersen@oracle.com, mst@redhat.com, jasowang@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org, hch@lst.de, pbonzini@redhat.com
List-Id: linux-scsi@vger.kernel.org

Earlier discussion:
https://lkml.org/lkml/2017/8/4/601
"Increased memory usage with scsi-mq"

Downstream bug report:
https://bugzilla.redhat.com/show_bug.cgi?id=1478201
