From: Mike Galbraith <efault@gmx.de>
Subject: Re: Large amount of scsi-sgpool objects
Date: Wed, 04 Mar 2009 08:12:32 +0100
Message-ID: <1236150752.6049.19.camel@marge.simson.net>
References: <49ACF8FE.2020904@panasas.com>
	 <1236093718.3263.3.camel@localhost.localdomain>
	 <alpine.LSU.2.00.0903031703270.855@fbirervta.pbzchgretzou.qr>
	 <1236097526.3263.17.camel@localhost.localdomain>
	 <20090303192212.GA20705@elte.hu>
	 <1236115544.15993.22.camel@localhost.localdomain>
	 <20090303214454.GA8288@elte.hu>
	 <1236119990.24019.35.camel@localhost.localdomain>
	 <20090303230323.GA21644@elte.hu> <49ADBE29.4040706@s5r6.in-berlin.de>
	 <20090303234834.GA13389@elte.hu>  <49AE221D.9010909@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rt-users-owner@vger.kernel.org>
In-Reply-To: <49AE221D.9010909@s5r6.in-berlin.de>
Sender: linux-rt-users-owner@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Ingo Molnar <mingo@elte.hu>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jan Engelhardt <jengelh@medozas.de>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-rt-users@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2009-03-04 at 07:39 +0100, Stefan Richter wrote:
> Ingo Molnar wrote:
> > * Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> Perhaps you could avoid putting such fixes into published 
> >> merge branches.
> [so that consumers of the trees use them only on demand]
> > 
> > Yeah, these commits are in none of the topic branches that are 
> > the git base of development, they are all already in a separate 
> > branch named "tip:out-of-tree".
> 
> So people should remember to retry without out-of-tree before reporting
> problems == remember to report against the development base.

I'll bite, how does a gut-fu white belt accomplish that?

	-Mike

