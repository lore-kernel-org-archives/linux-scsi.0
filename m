From: Christoph Hellwig <hch@infradead.org>
Subject: [PATCH 0/3] next round of blk-mq updates
Date: Thu, 20 Feb 2014 15:32:35 -0800
Message-ID: <20140220233235.443299098@bombadil.infradead.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

A couple more blkmq updates: a trivial cleanup, a consolidation of two very
similar functions into one, and support for partial request completions,
a feature needed by the work in progress scsi blk-mq support.
