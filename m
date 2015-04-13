From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH RFC v2] mpt2/mpt3sas lock reduction for scsi-mq
Date: Mon, 13 Apr 2015 11:50:20 +0200
Message-ID: <20150413095020.GF5259@lst.de>
References: <1428427120-20971-1-git-send-email-axboe@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1428427120-20971-1-git-send-email-axboe@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, hch@lst.de
List-Id: linux-scsi@vger.kernel.org

This looks good modulo my minor comments and using and testing the
new code path for the !mq case as well.  Please also Cc the Avago
people on your next submission.
