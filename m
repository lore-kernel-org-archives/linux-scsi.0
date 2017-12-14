From: Hannes Reinecke <hare@suse.de>
Subject: [PATCH 0/3] virtio-vfc implementation
Date: Thu, 14 Dec 2017 11:11:53 +0100
Message-ID: <1513246316-56019-1-git-send-email-hare@suse.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50292 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751832AbdLNKMA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 Dec 2017 05:12:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, Paolo Bonzini <pbonzini@redhat.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

Hi all,

here's my attempt to implement a 'Virtual FC' emulation for virtio-scsi,
based on the presentation at the KVM Forum in Prague.

This doesn't so much implement the FC protocol per se, it just uses the
port information to hook in the FC transport class, making the device
to look like a FC device.

This patchset has a complementary patchset for the qemu virtio-scsi driver,
which will be posted to the qemu-devel list.

As usual, comments and reviews are welcome.

Hannes Reinecke (3):
  virtio-scsi: implement target rescan
  virtio-scsi: Add FC transport class
  virtio_scsi: Implement 'native LUN' feature

 drivers/scsi/virtio_scsi.c       | 582 ++++++++++++++++++++++++++++++++++++---
 include/uapi/linux/virtio_scsi.h |  16 ++
 2 files changed, 554 insertions(+), 44 deletions(-)

-- 
1.8.5.6
