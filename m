From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Mon, 4 Aug 2014 04:11:47 -0700
Message-ID: <20140804111147.GA29148@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <1406925121.2654.21.camel@jarvis>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1406925121.2654.21.camel@jarvis>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>
List-Id: linux-scsi@vger.kernel.org

On Fri, Aug 01, 2014 at 04:32:01PM -0400, James Bottomley wrote:
> On Fri, 2014-08-01 at 05:20 -0700, Christoph Hellwig wrote:
> > I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
> > branches.
> 
> So I'm afraid we missed the last -next build on these, so they can't go
> in with the early SCSI pull.  I'm open to doing one mid merge window,
> but Linus tends not to like that.

I don't think there are any hard and fast rules.


The core-for-3.17 commit is a trivial printk specifier regression fix for
something introduced in the 3.17 merge window, so pulling it in is
an absolute non-brainer.

The drivers side are a bunch of smaller fixes for iscsi and pm8001 which
never have been a problem to put in near the end of the merge window,
especially if they have a few more days linux-next exposure in
Linux-next even after the 3.16 release.  They absolutely would be
candidates for a second pull even if they'd miss the first pull.
