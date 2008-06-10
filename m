From: Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH 0 of 7] Block/SCSI Data Integrity Support
Date: Tue, 10 Jun 2008 10:41:45 -0400
Message-ID: <x491w35bbdi.fsf@segfault.boston.devel.redhat.com>
References: <patchbomb.1212814533@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:47440 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666AbYFJOm4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 10 Jun 2008 10:42:56 -0400
In-Reply-To: <patchbomb.1212814533@sermon.lab.mkp.net> (Martin K. Petersen's
	message of "Sat, 07 Jun 2008 00:55:33 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

"Martin K. Petersen" <martin.petersen@oracle.com> writes:

> Another post of my block I/O data integrity patches.  This kit goes on
> top of the scsi_data_buffer and sd.h cleanups I posted earlier today.

Pointers to archives would have been appreciated.  I can't, for the life
of me, find these.

> There has been no changes to the block layer code since my last
> submission.
>
> Within SCSI, the changes are cleanups based on comments from Christoph
> as well as working support for Type 3 and 4KB sectors.

Thanks for all of the great documentation.  It would be good to include
some instructions on how one would test this, and what testing you
performed.  Also, please use the '-p' switch to diff, as it makes
reviewing patches much easier.

I set out to try your changes, but ran into some problems.  First, this
patch set didn't apply cleanly to a git checkout.  So, I grabbed your
mercurial repository, but got a build failure:

block/blk-core.c: In function 'generic_make_request':
include/linux/bio.h:469: sorry, unimplemented: inlining failed in call to 'bio_i
ntegrity_enabled': function body not available
block/blk-core.c:1388: sorry, unimplemented: called from here
make[1]: *** [block/blk-core.o] Error 1
make: *** [block] Error 2

Cheers,

Jeff
