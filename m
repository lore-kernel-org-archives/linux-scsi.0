From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Fri, 8 Feb 2008 00:05:35 -0500
Message-ID: <20080208050535.GA4061@infradead.org>
References: <1202432206.3171.53.camel@localhost.localdomain> <20080207184606.03b28a9c.akpm@linux-foundation.org> <alpine.LFD.1.00.0802071909350.2896@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1752862AbYBHFFy@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.00.0802071909350.2896@woody.linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>
List-Id: linux-scsi@vger.kernel.org

On Thu, Feb 07, 2008 at 07:11:33PM -0800, Linus Torvalds wrote:
> 
> 
> On Thu, 7 Feb 2008, Andrew Morton wrote:
> > 
> > Sob.  Can we please merge "Convert SG from nopage to fault"?
> 
> Heh. I just took it directly then.
> 
> I think it's more of a VM patch than a SCSI patch anyway, so I don't think 
> you really should even have tried to push it through the SCSI tree.
> 
> It's not like we ever do the low-level FS changes for VFS issues through 
> the FS maintainers anyway (ie you sent me all those iget/read_inode things 
> directly rather than trying to go through each filesystem). I don't think 
> this is any different, really.

Yes.  For ->faul Nick should just have sent on the whole batch after
giving fs/driver people enough time to review it.
