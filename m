From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH][2.6.8-rc1-mm1] drivers/scsi/sg.c gcc341 inlining fix
Date: Thu, 15 Jul 2004 07:56:56 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040715055655.GE9383@suse.de>
References: <200407141751.i6EHprhf009045@harpo.it.uu.se> <40F57D14.9030005@pobox.com> <20040714143508.3dc25d58.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:38062 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S266016AbUGOF5Q (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jul 2004 01:57:16 -0400
Content-Disposition: inline
In-Reply-To: <20040714143508.3dc25d58.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: Jeff Garzik <jgarzik@pobox.com>, mikpe@csd.uu.se, B.Zolnierkiewicz@elka.pw.edu.pl, dgilbert@interlog.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Jul 14 2004, Andrew Morton wrote:
> Jeff Garzik <jgarzik@pobox.com> wrote:
> >
> > Or you could just call it "gcc is dumb" rather than a compiler bug.
> 
> Yeah, but doing:
> 
> 	static inline foo(void);
> 
> 	bar()
> 	{
> 		...
> 		foo();
> 	}
> 
> 	static inline foo(void)
> 	{
> 		...
> 	}
> 
> is pretty dumb too.  I don't see any harm if this compiler feature/problem
> pushes us to fix the above in the obvious way.

Excuse my ignorance, but why on earth would that be dumb? Looks
perfectly legit to me, and I have to agree with Jeff that the compiler
is exceedingly dumb if it fails to inline that case.

-- 
Jens Axboe

