From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: ioctls, etc. (was Re: [PATCH 1/4] sas: add flag for locally attached PHYs)
Date: Sat, 22 Oct 2005 10:30:44 -0700 (PDT)
Message-ID: <20051022173044.5903.qmail@web31808.mail.mud.yahoo.com>
References: <20051022105815.GB3027@infradead.org>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31808.mail.mud.yahoo.com ([68.142.207.71]:64883 "HELO
	web31808.mail.mud.yahoo.com") by vger.kernel.org with SMTP
	id S1750854AbVJVRap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 22 Oct 2005 13:30:45 -0400
In-Reply-To: <20051022105815.GB3027@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@pobox.com>, Luben Tuikov <luben_tuikov@adaptec.com>, andrew.patterson@hp.com, Christoph Hellwig <hch@lst.de>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, jejb@steeleye.com, Linus Torvalds <torvalds@osdl.org>

--- Christoph Hellwig <hch@infradead.org> wrote:
> On Sat, Oct 22, 2005 at 12:42:27PM +0200, Stefan Richter wrote:
> > A. Post mock-ups and pseudo code about how to change the core, discuss.
> > B. Set up a scsi-cleanup tree. In this tree,
> >      1. renovate the core (thereby break all command set drivers and
> >         all transport subsystems),
> 
> No way.  Doing things from scatch is a really bad idea.  See how far we came
> with Linux 2.6 scsi vs 2.4 scsi without throwing everything away and break
> the
> world.  Please submit changes to fix _one_ thing at a time and fix all users.
> Repeat until done or you don't care anymore.

No offence Christoph, but who are you again?

There is a clear reason why you among others do not want new architecture.
And that reason is (people) obsoletion.

Such political stance cannot go on forever -- just look at History.
Sooner or later things change and they change radically.  The question
is How prepared are you/we to cope with this (inevitable) change?

Either way, obsoletion or adoption -- think about it, it doesn't only apply
to computer and OS design, it applies to everything.

    Luben




-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
