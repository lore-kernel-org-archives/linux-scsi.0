From: Ming Lin <mlin@kernel.org>
Subject: [PATCH RFC 0/2] mempool based chained scatterlist alloc/free api api
Date: Tue, 15 Mar 2016 15:39:27 -0700
Message-ID: <1458081569-30953-1-git-send-email-mlin@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

From: Ming Lin <ming.l@ssi.samsung.com>

Hi list,

This moves the mempool based chained scatterlist alloc/free code from
scsi_lib.c to lib/scatterlist.c.

So other drivers(for example, the under development NVMe over fabric drivers)
can also use it.

Ming Lin (2):
  scatterlist: add mempool based chained SG alloc/free api
  scsi: use the new chained SG api

 drivers/scsi/scsi_lib.c     | 129 ++----------------------------------
 include/linux/scatterlist.h |  12 ++++
 lib/scatterlist.c           | 156 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 175 insertions(+), 122 deletions(-)

-- 
1.9.1
