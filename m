From: Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH for 3.6 0/3] urgent virtio-scsi fixes
Date: Tue, 28 Aug 2012 13:59:11 +0200
Message-ID: <1346155154-12915-1-git-send-email-pbonzini@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, kvm@vger.kernel.org, jbottomley@parallels.com
List-Id: linux-scsi@vger.kernel.org

James,

here are three important bugfixes for virtio-scsi.  All three have been
on the list for a while, I'm grouping them in this post to ease your
processing.

Two of them are also marked for stable branches.

Paolo

Paolo Bonzini (1):
  virtio-scsi: fix LUNs greater than 255

Richard W.M. Jones (1):
  virtio-scsi: initialize scatterlist structure for events

Wang Sen (1):
  virtio-scsi: fix copying of sg_list in the presence of of HighMem pages

 drivers/scsi/virtio_scsi.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)
