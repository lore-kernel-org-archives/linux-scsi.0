From: Christoph Hellwig <hch@lst.de>
Subject: add a proper completion queue abstraction
Date: Fri, 13 Nov 2015 14:46:41 +0100
Message-ID: <1447422410-20891-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org
Cc: sagig@dev.mellanox.co.il, bart.vanassche@sandisk.com, axboe@fb.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This series adds a new RDMA core abstraction that insulated the
ULPs from the nitty gritty details of CQ polling.  See the individual
patches for more details.

Note that this series should be applied on top of my
"IB: merge struct ib_device_attr into struct ib_device" patch.

A git tree is also available:

	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma-cq
	git://git.infradead.org/users/hch/rdma.git rdma-cq
