From: Jamie Lokier <jamie@shareable.org>
Subject: Re: O_DIRECT and barriers
Date: Thu, 27 Aug 2009 15:34:59 +0100
Message-ID: <20090827143459.GB31453@shareable.org>
References: <1250697884-22288-1-git-send-email-jack@suse.cz> <20090820221221.GA14440@infradead.org> <20090821114010.GG12579@kernel.dk> <20090821135403.GA6208@shareable.org> <20090821142635.GB30617@infradead.org> <20090821152459.GC6929@shareable.org> <20090821174525.GA28861@infradead.org> <20090822005006.GA22530@shareable.org> <20090824023422.GA775@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090824023422.GA775@infradead.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> Then again they already don't get what they expect and never did,
> so if we clear document and communicate the O_SYNC (that is Linux
> O_SYNC) requirement we might be able to go with this.

I'm thinking, while we're looking at this, that now is a really good
time to split up O_SYNC and O_DSYNC.

We have separate fsync and fdatasync, so it should be quite tidy now.

Then we can document using O_DSYNC on Linux, which is fine for older
versions because it has the same value as O_SYNC at the moment.

-- Jamie
