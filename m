From: torvalds@transmeta.com (Linus Torvalds)
Subject: Re: [PATCH] aic7xxx bouncing over 4G
Date: Sun, 22 Dec 2002 00:16:22 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <au308m$14b$1@penguin.transmeta.com>
References: <200212210012.gBL0Cng21338@eng2.beaverton.ibm.com> <20021221085510.A25881@infradead.org> <4093022704.1040484612@aslan.scsiguy.com> <20021221174554.GA9703@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by neon-gw.transmeta.com (8.9.3/8.9.3) id QAA16959
	for <linux-scsi@vger.kernel.org>; Sat, 21 Dec 2002 16:18:21 -0800
Received: from palladium.transmeta.com (palladium.transmeta.com [10.1.1.46])
	by deepthought.transmeta.com (8.11.6/8.11.6) with ESMTP id gBM0II301573
	for <linux-scsi@vger.kernel.org>; Sat, 21 Dec 2002 16:18:18 -0800 (PST)
Received: (from mail@localhost)
	by palladium.transmeta.com (8.9.3/8.9.3) id QAA10940
	for linux-scsi@vger.kernel.org; Sat, 21 Dec 2002 16:18:17 -0800
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <20021221174554.GA9703@redhat.com>,
Doug Ledford  <dledford@redhat.com> wrote:
>
>I actually like the individual file comments part of the cset setup.  It's 
>what my preferred use is when I'm making my own patches.  Make the cset 
>have a summary of the major changes, then let each file have it's own 
>detail change information.

I do that too, but on the whole I tend to think that if the per-file
comments are really needed (as opposed to being just nice extra and
mostly uninteresting details), there's something wrong with the CSet. 

For example, all the regular changelog tools just use the main cset
comment, and discard the file comments.  So my own rule is that the file
comments should be something fairly small and insignificant, and a good
cset should really be sufficiently explained by the cset comment. 

If the changes are so involved that you only end up condensing the
per-file comments for the global cset comment, and the per-file comments
are really interesting, then maybe that cset should have been split up
in the first place.. 

			Linus
