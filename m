From: Christoph Hellwig <hch@lst.de>
Subject: sense handling improvements
Date: Tue, 14 Feb 2017 20:15:54 +0100
Message-ID: <20170214191600.17480-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernek.dk
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi all,

this series is on top of the scsi_request changes in Jens' tree and
further improves the handling of the sense buffer.

The first patch prevents any possibily of reusing stale sense codes
in sense headers, and is a bug fix that we should probably get into
the block tree ASAP.

The rest cleans up handling of the parsed sense data and could go in
either through the block tree, or a SCSI branch on top of the block
tree.
