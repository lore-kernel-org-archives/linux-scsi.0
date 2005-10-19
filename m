From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] scsi_error thread exits in TASK_INTERRUPTIBLE state.
Date: Wed, 19 Oct 2005 13:56:53 +0200
Message-ID: <20051019115653.GA2127@elte.hu>
References: <5bdc1c8b0510181402o2d9badb0sd18012cf7ff2a329@mail.gmail.com> <1129693423.8910.54.camel@mindpipe> <1129695564.8910.64.camel@mindpipe> <Pine.LNX.4.58.0510190300010.20634@localhost.localdomain> <Pine.LNX.4.58.0510190349590.20634@localhost.localdomain> <20051019113131.GA30553@infradead.org> <Pine.LNX.4.58.0510190751070.20634@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:32472 "EHLO mx2.mail.elte.hu")
	by vger.kernel.org with ESMTP id S1750827AbVJSL45 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 07:56:57 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0510190751070.20634@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Christoph Hellwig <hch@infradead.org>, Lee Revell <rlrevell@joe-job.com>, Mark Knecht <markknecht@gmail.com>, linux-kernel@vger.kernel.org, rmk@arm.linux.org.uk, Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>, andmike@us.ibm.com, linux-scsi@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 19 Oct 2005, Christoph Hellwig wrote:
> 
> > > +	/*
> > > +	 * There's a good chance that the loop will exit in the
> > > +	 * TASK_INTERRUPTIBLE state.
> > > +	 */
> > > +	__set_current_state(TASK_RUNNING);
> >
> > no need to comment the obvious.
> 
> So, should I resend the patch without the comment?

i guess so. OTOH, if it was so obvious, why did it stay unfixed for so 
long ;-)

	Ingo
