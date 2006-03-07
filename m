From: Christoph Hellwig <hch@infradead.org>
Subject: Re: osst changes required to move forward to block request
Date: Tue, 7 Mar 2006 11:59:13 +0000
Message-ID: <20060307115913.GA30421@infradead.org>
References: <20060206131944.GA1769@lst.de> <1139274141l.7464l.1l@athena.riede.org> <20060207091254.GA11691@infradead.org> <1139687216l.24984l.0l@athena.riede.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:40424 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1752484AbWCGL7Q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 7 Mar 2006 06:59:16 -0500
Content-Disposition: inline
In-Reply-To: <1139687216l.24984l.0l@athena.riede.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Willem Riede <osst@riede.org>
Cc: Christoph Hellwig <hch@infradead.org>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org

On Sat, Feb 11, 2006 at 02:46:56PM -0500, Willem Riede wrote:
> On 02/07/2006 04:12:55 AM, Christoph Hellwig wrote:
> > On Mon, Feb 06, 2006 at 08:02:21PM -0500, Willem Riede wrote:
> > 
> > > But I will certainly help retire scsi_request. And anything else that is  
> > > needed to keep up with proper kernel style. Let me know what those are, if 
> > > you  would? I'll start looking at how st has changed, and will be back with 
> > > any  questions I may have.
> > 
> > right now the above is the most urgent bit.  What would be nice but not
> > required is a conversion to the sense handling helpers, similar to what
> > st got (aka using the *normalize_sense functions and then dealing with the
> > parsed sense buffer instead of the raw sense data)
> 
> Ok, so here is my first take at satisfying this request.
> Be warned, that beyond compiling, and checking that the new module
> doesn't immediately blow up, there hasn't yet been a lot of testing.
> 
> But this should allow you to comment on the changes, and move forward
> with dropping scsi_request from the kernel code.
> 
> Signed-off-by: Willem Riede <osst@riede.org>

James, could you put this into the scsi-misc tree so we don't have any ULD
using the scsi_request APIs anymore?

