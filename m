From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Date: Mon, 4 Aug 2014 04:34:04 -0700
Message-ID: <20140804113404.GA11377@infradead.org>
References: <20140708134003.GA7790@infradead.org>
 <20140801122042.GA10771@infradead.org>
 <1406925121.2654.21.camel@jarvis>
 <20140804111147.GA29148@infradead.org>
 <20140804213059.32fd25d5@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140804213059.32fd25d5@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Aug 04, 2014 at 09:30:59PM +1000, Stephen Rothwell wrote:
> You realise that neither of these in linux-next as the scsi-core and
> scsi-drivers trees had for-3.16 branches in the last round.  I assume I
> should just drop these trees completely from linux-next?

Well, they get pulled in through James, so you can drop them for now.

I mostly put you on Cc so you could comment wether there are any hard
rules on how long even those simple fixes should be in linux-next.  I
know you've put up stats for a few of the last merge windows about
patches that weren't in linux-next, so there's been some tracking of it
for sure.
