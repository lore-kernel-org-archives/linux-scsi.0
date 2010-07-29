From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC] relaxed barrier semantics
Date: Thu, 29 Jul 2010 22:03:27 +0200
Message-ID: <20100729200327.GA17767@lst.de>
References: <20100728085048.GA8884@lst.de> <4C4FF136.5000205@kernel.org> <20100728090025.GA9252@lst.de> <4C4FF592.9090800@kernel.org> <20100728092859.GA11096@lst.de> <20100729014431.GD4506@thunk.org> <4C51DA1F.2040701@redhat.com> <20100729194904.GA17098@lst.de> <4C51DCF1.3010507@redhat.com> <1280433591.4441.393.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1280433591.4441.393.camel@mulgrave.site>
Sender: linux-fsdevel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Ric Wheeler <rwheeler@redhat.com>, Christoph Hellwig <hch@lst.de>, Ted Ts'o <tytso@mit.edu>, Tejun Heo <tj@kernel.org>, Vivek Goyal <vgoyal@redhat.com>, Jan Kara <jack@suse.cz>, jaxboe@fusionio.com, linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org, chris.mason@oracle.com, swhiteho@redhat.com, konishi.ryusuke@lab.ntt.co.jp
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 29, 2010 at 02:59:51PM -0500, James Bottomley wrote:
> That's basically everything FUA ... you might just as well switch your
> cache to write through and have done.
> 
> This, by the way, is one area I'm hoping to have researched on SCSI
> (where most devices do obey the caching directives).  Actually see if
> write through without flush barriers is faster than writeback with flush
> barriers.  I really suspect it is.

We have done the research and at least for XFS a write through cache
actually is faster for many workloads.  Ric always has workloads where
the cache is faster, though - mostly doing lots of small file write
kind of setups.

