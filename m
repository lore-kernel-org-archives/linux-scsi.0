From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH, RFC] xfs: batched discard support
Date: Sun, 16 Aug 2009 09:53:15 -0400
Message-ID: <20090816135315.GA25251@infradead.org>
References: <20090816004705.GA7347@infradead.org> <4A876255.10606@rtr.ca> <4A876CA9.20906@rtr.ca> <20090816022500.GA12392@infradead.org> <4A8802F3.6010908@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A8802F3.6010908@rtr.ca>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org, jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-scsi@vger.kernel.org

On Sun, Aug 16, 2009 at 09:00:35AM -0400, Mark Lord wrote:
> Okay, this gives me ENOSYS now --> discard/trim support is missing from
> the lower layers.

ENOSYS or EOPNOTSUPP?

> What other patches do I need to make this work?
>
> The latest from Matthew's discard tree (May 2009) don't appear to be sufficient,
> even after updating them for 2.6.31-rc6.

Hmm.  That was kinda the reason why I didn't want to post stuff yet.  In
current mainline only MTD implements the prepare_discard_fn, and we'll
need it implemented and working.  I think Matthews patches should be
sufficient, unless they have some ATA revision check to not issue the
TRIM for your device.

