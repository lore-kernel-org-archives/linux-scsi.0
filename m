From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [GIT PATCH] scsi bug fixes for 2.6.23-rc2
Date: Tue, 7 Aug 2007 10:47:20 -0700
Message-ID: <20070807104720.d4b238b6.akpm@linux-foundation.org>
References: <alpine.LFD.0.999.0708061748240.5037@woody.linux-foundation.org>
	<1186458941.6637.44.camel@localhost.localdomain>
	<20070807001429.f8cb3b22.akpm@linux-foundation.org>
	<20070806162823P.tomof@acm.org>
	<46B87FDE.3050309@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57548 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765304AbXHGRsK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Aug 2007 13:48:10 -0400
In-Reply-To: <46B87FDE.3050309@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: FUJITA Tomonori <tomof@acm.org>, James.Bottomley@SteelEye.com, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 07 Aug 2007 10:21:18 -0400 Jeff Garzik <jeff@garzik.org> wrote:

> FUJITA Tomonori wrote:
> > On Tue, 7 Aug 2007 00:14:29 -0700
> > Andrew Morton <akpm@linux-foundation.org> wrote:
> > 
> >> On Mon, 06 Aug 2007 22:55:41 -0500 James Bottomley <James.Bottomley@SteelEye.com> wrote:
> >>
> >>> The real root cause of all of this is that there's no tree I can
> >>> persuade all the interested parties to test that includes all of these
> >>> features.  In spite of the fact they've all been incubating in -mm for
> >>> at least 3 months, no-one apparently tested all the features together
> >>> until 2.6.23-rc1 was released, so then we're scrambling to address the
> >>> issues as they arise.
> >> I pulled git-scsi-misc on July 19 and there was no bsg code in there at
> >> all.  I pulled again on July 20 and all the bsg code was in mainline.  So
> >> it appears that the bsg code went mailing-list -> mainline in less than 24
> >> hours, so there wasn't a lot of opportunity for -mm testing there.
> > 
> > bsg was merged via Jens' branch. After that, I asked James to send
> > some fixes via the scsi-rc-fixes.
> 
> ISTR that Jens doesn't regularly push / get picked up by -mm?  That 
> seems like an easy problem to solve.
> 

-mm includes
git+ssh://master.kernel.org/pub/scm/linux/kernel/git/axboe/linux-2.6-block.git#for-akpm,
but it's up to Jens to choose what goes in there.

git-block has been dropped from -mm since 2.6.23-rc1-mm1 (I think) because
it has something in there which breaks sata on the Vaio.  Prior to that (in
2.6.22-rc-late) there was nothing in that tree.

