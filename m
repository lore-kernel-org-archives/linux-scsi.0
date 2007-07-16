From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 00/33] SG table chaining support
Date: Mon, 16 Jul 2007 18:43:10 +0200
Message-ID: <20070716164309.GA5195@kernel.dk>
References: <11845792671245-git-send-email-jens.axboe@oracle.com> <18075.31515.974905.507754@stoffel.org> <yq1d4ysv35d.fsf@sermon.lab.mkp.net> <Pine.LNX.4.64.0707161852380.5065@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([80.160.20.94]:12070 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760284AbXGPQnu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jul 2007 12:43:50 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0707161852380.5065@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, John Stoffel <john@stoffel.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mon, Jul 16 2007, Kai Makisara wrote:
> On Mon, 16 Jul 2007, Martin K. Petersen wrote:
> 
> > >>>>> "John" == John Stoffel <john@stoffel.org> writes:
> > 
> > John> Will this help out tape drive performance at all?  I looked
> > John> through the patches quickly, esp the AIC7xxx stuff since that's
> > John> what I use, but nothing jumped out at me...
> > 
> > Yes.  Most modern tape drives want a block size of 1MB or higher.
> > With the old stack we'd be stuck at 512KB because the sg limitations
> > caused us to come just short of 1MB...
> > 
> Tape block sizes up to 16 MB have been possible for a very long time but 
> this has required tuning of the block/scsi parameters. Very few people 
> seem to have done this and the common (mis)belief seems to be that the 
> tape block size limit has been 512 kB. It is good if this tuning is not
> needed in future.

The main difference is now you get to do it without hacks and in a clean
way, so it works through the normal IO path and not some on-the-side
thing (or st only).

-- 
Jens Axboe

