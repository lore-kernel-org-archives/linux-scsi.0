From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 12:37:34 +0100
Message-ID: <20071207113734.GA14598@elte.hu>
References: <20071206163305.c3587675.akpm@linux-foundation.org> <20071207050709.110D2DBA2@gherkin.frus.com> <20071207022646.373c92f5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:34167 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751503AbXLGLiD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 7 Dec 2007 06:38:03 -0500
Content-Disposition: inline
In-Reply-To: <20071207022646.373c92f5.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com


* Andrew Morton <akpm@linux-foundation.org> wrote:

> > then the test of whether I bisected correctly is as simple as 
> > applying the commit and seeing if things break, because I'm running 
> > on the kernel corresponding to 
> > 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 right now.  Let me give 
> > that a try and I'll report back.  Worst case, I'll have to start 
> > over and write off the past four days...
> 
> Gad.  I trust the second time will be faster.
> 
> git-bisect _is_ very error prone.  I find one of the problems is that 
> each step is so far apart in time that you forget what you were doing.  
> Did I remember to test that iteration?  Did I install the right 
> kernel?  etc.

i have a fully automated bootup-hang bisection script. It is based on 
"git-bisect run". I run the script, it builds and boots kernels fully 
automatically, and when the bootup fails (the script notices that via 
the serial log, which it continuously watches - or via a timeout, if the 
system does not come up within 10 minutes it's a "bad" kernel), the 
script raises my attention via a beep and i power cycle the test box. 
(yeah, i should make use of a managed power outlet to 100% automate it) 

So i dont have to a single manual decision anytime during the bisection. 
But the scripts are very much tied to my ad-hoc test environment so it 
would not be of much general use.

	Ingo
