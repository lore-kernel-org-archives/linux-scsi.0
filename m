From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 01/16] block: fix elevator init check
Date: Tue, 24 Jan 2017 16:10:41 +0100
Message-ID: <20170124151041.GB27705@lst.de>
References: <1485185361-29786-1-git-send-email-hch@lst.de> <1485185361-29786-2-git-send-email-hch@lst.de> <20170124150639.GA22198@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170124150639.GA22198@kernel.dk>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@fb.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2017 at 08:06:39AM -0700, Jens Axboe wrote:
> We check for REQ_PREFLUSH | REQ_FUA in so many places though, might not
> be a bad idea to keep the helper but just make it take the opf and fix
> up the other locations too. The fact that PREFLUSH|FUA is the magic to
> check for is somewhat tribal knowledge.

I'll see if I can come up with something sensible.  The current
helper using the bio and the magic 0 value is not exactly helpful.
