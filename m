From: Christoph Hellwig <hch@lst.de>
Subject: three little req->errors follow ups
Date: Wed, 26 Apr 2017 09:34:19 +0200
Message-ID: <20170426073422.14511-1-hch@lst.de>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

While moving forward with the block error work I noticed three more
places that pass non-errno values to the end_request variants, and
never actually check those return values.  This little series fixes
those up to always pass 0.
