From: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: 2.6.30-rc2-git2: Reported regressions from 2.6.29
Date: Sat, 9 May 2009 18:37:12 -0300
Message-ID: <20090509183712.54ac4c79@pedra.chehab.org>
References: <EJaiQ4Wfaz.A.3YG.4v85JB@chimera>
	<200904202208.23899.laurent.pinchart@skynet.be>
	<d82e647a0904201847n403424efnb5a0c40a4cac365d@mail.gmail.com>
	<200904220121.12002.laurent.pinchart@skynet.be>
	<20090509112819.759594d5@linux-lm>
	<alpine.LFD.2.01.0905090923370.3586@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:57444 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbZEIVhx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 9 May 2009 17:37:53 -0400
In-Reply-To: <alpine.LFD.2.01.0905090923370.3586@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Laurent Pinchart <laurent.pinchart@skynet.be>, "Rafael J. Wysocki" <rjw@sisk.pl>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Adrian Bunk <bunk@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Natalie Protasevich <protasnb@gmail.com>, Kernel Testers List <kernel-testers@vger.kernel.org>, Network Development <netdev@vger.kernel.org>, Linux ACPI <linux-acpi@vger.kernel.org>, Linux PM List <linux-pm@lists.linux-foundation.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, video4linux-list@redhat.com

Em Sat, 9 May 2009 09:24:51 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> escreveu:

> 
> 
> On Sat, 9 May 2009, Ming Lei wrote:
> > 
> > Rc5 has been released today, why isn't this patch accepted by upstream
> > now?  It is really a bug fix.


> 
> I can take it directly, but was hoping to get it through the regular DVB 
> tree. Haven't had a DVB update request yet (or maybe it got lost?)
> 
> 		Linus

The patch were added on my linux-next tree. I'll move it to the tree I handle
bug fixes and I'll ask Linus to pull from it together with a few other fixes I
have there, later today or tomorrow.




Cheers,
Mauro
