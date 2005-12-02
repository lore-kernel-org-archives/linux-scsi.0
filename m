From: Hugh Dickins <hugh@veritas.com>
Subject: Re: Fw: crash on x86_64 - mm related?
Date: Fri, 2 Dec 2005 20:40:56 +0000 (GMT)
Message-ID: <Pine.LNX.4.61.0512022037230.6058@goblin.wat.veritas.com>
References: <20051129092432.0f5742f0.akpm@osdl.org>
 <Pine.LNX.4.63.0512012040390.5777@kai.makisara.local>
 <Pine.LNX.4.64.0512011136000.3099@g5.osdl.org> <20051201195657.GB7236@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512012008420.28450@goblin.wat.veritas.com>
 <20051202180326.GB7634@tau.solarneutrino.net>
 <Pine.LNX.4.61.0512021856170.4940@goblin.wat.veritas.com>
 <20051202194447.GA7679@tau.solarneutrino.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1751135AbVLBUlF@vger.kernel.org>
Received: from linux.wat.veritas.com([10.10.97.50]) (1840 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1EiHiD-0001IWC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 2 Dec 2005 12:40:57 -0800 (PST)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <20051202194447.GA7679@tau.solarneutrino.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Ryan Richter <ryan@tau.solarneutrino.net>
Cc: Linus Torvalds <torvalds@osdl.org>, Kai Makisara <Kai.Makisara@kolumbus.fi>, Andrew Morton <akpm@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 2 Dec 2005, Ryan Richter wrote:
> 
> OK, I guess I'll stick with 2.6.14.3 for now, plus your patch.  Should I
> keep Kai's st.c patch?  There was some mention of other patches, are
> those relevant?  Most of that discussion went over my head...

For the "Bad page state" premature freeing you were seeing, only my
patch should be relevant.  There are other patches in the works, yes,
and we have good reasons for them; but don't worry about them for this.

Hugh
