From: Ingo Molnar <mingo@elte.hu>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 4 Mar 2009 12:47:30 +0100
Message-ID: <20090304114730.GA6736@elte.hu>
References: <1236119990.24019.35.camel@localhost.localdomain> <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de> <20090303234834.GA13389@elte.hu> <49AE221D.9010909@s5r6.in-berlin.de> <1236150752.6049.19.camel@marge.simson.net> <49AE32B5.9040603@s5r6.in-berlin.de> <alpine.LFD.2.00.0903041004300.29264@localhost.localdomain> <20090304111235.GA14593@elte.hu> <49AE65EE.5020605@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.mail.elte.hu ([157.181.151.9]:54208 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756890AbZCDLru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 Mar 2009 06:47:50 -0500
Content-Disposition: inline
In-Reply-To: <49AE65EE.5020605@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>


* Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:

> Ingo Molnar wrote:
> > * Thomas Gleixner <tglx@linutronix.de> wrote:
> >> On Wed, 4 Mar 2009, Stefan Richter wrote:
> >> > As I said, I recommend that people do not receive those off-topic
> >> > patches by default, only on demand.  (Because I sometimes work with -rt
> >> > users.)
> >> 
> >> And as I said before, I missed to remove the patch before pushing out
> >> the -rt tree. So I really do not need repeated advise on how to do my
> >> work.
> > 
> > yeah. I dont think Stefan ever maintained a high-volume generic 
> > tree before. Kibitzing from the sidelines always makes it seem 
> > so easy ;-)
> 
> You could also take this "I recommend..." not as advice how to 
> do your work but rather as a /user request/ regarding the 
> outcome of your work.

Oh, so you use -tip? I didnt know that ... never got any 
feedback from you i guess it's trouble-free. So you like its 
stability?

	Ingo
