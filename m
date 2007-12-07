From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Thu, 6 Dec 2007 23:42:25 -0600 (CST)
Message-ID: <20071207054225.06D68DBA3@gherkin.frus.com>
References: <20071206163305.c3587675.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gherkin.frus.com ([192.158.254.49]:36091 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753123AbXLGFm3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 00:42:29 -0500
In-Reply-To: <20071206163305.c3587675.akpm@linux-foundation.org>
 "from Andrew Morton at Dec 6, 2007 04:33:05 pm"
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mingo@elte.hu, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com

I wrote:
> If the implicated commit is the next one in time
> sequence relative to
> 
> # good: [2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3] CRISv10 fasttimer: Scrap INLINE and name timeval_cmp better
> 
> then the test of whether I bisected correctly is as simple as applying
> the commit and seeing if things break, because I'm running on the
> kernel corresponding to 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right
> now.  Let me give that a try and I'll report back.

Verified that 6f37ac793d6ba7b35d338f791974166f67fdd9ba is the next
commit after the "good" kernel I'm running now.  The build is running,
and I should have an answer for us in a few hours.

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
