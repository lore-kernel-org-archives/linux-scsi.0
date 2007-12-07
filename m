From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 10:33:04 +0100
Message-ID: <20071207093304.GC21135@elte.hu>
References: <20071204121618.GA26132@elte.hu> <20071207001612.39E36DBA2@gherkin.frus.com> <20071206163305.c3587675.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:35816 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751014AbXLGJdg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 04:33:36 -0500
Content-Disposition: inline
In-Reply-To: <20071206163305.c3587675.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > # bad: [6f37ac793d6ba7b35d338f791974166f67fdd9ba] Merge branch 'master' of master.kernel.org:/pub/scm/linux/kernel/git/davem/net-2.6
> > git-bisect bad 6f37ac793d6ba7b35d338f791974166f67fdd9ba
> > # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> > git-bisect good 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3

> I'm struggling to see how any of those could have broken block device 
> mounting on alpha.  Are you sure you bisected right?

the bisection log looks healthy so far - with nicely alternating 
good/bad bisection points. Barring the possibility that the bug is 
non-deterministic, i'd guess the bisection points are OK, at least 
judging from their statistical properties.

but ... i went over the diffs too, and i fail to see how they could 
affect the bootup path of an Alpha box, which i suspect has no 
networking dependency up to the failure point.

	Ingo
