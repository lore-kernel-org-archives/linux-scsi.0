From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Add hpsa driver for HP Smart Array controllers.
Date: Sat, 3 Oct 2009 11:22:49 -0700
Message-ID: <20091003112249.5fb1b241.akpm@linux-foundation.org>
References: <20091001211705.15591.76403.stgit@beardog.cce.hp.com>
	<20091001143035.a83a7564.akpm@linux-foundation.org>
	<20091002191626.GA17862@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50110 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752220AbZJCSXn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 3 Oct 2009 14:23:43 -0400
In-Reply-To: <20091002191626.GA17862@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Miller <mike.miller@hp.com>
Cc: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>, James.Bottomley@HansenPartnership.com, axboe@kernel.dk, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, mikem@beardog.cce.hp.com, jowens@hp.com

On Fri, 2 Oct 2009 14:16:26 -0500 Mike Miller <mike.miller@hp.com> wrote:

> On Thu, Oct 01, 2009 at 02:30:35PM -0700, Andrew Morton wrote:
> > On Thu, 01 Oct 2009 16:25:30 -0500
> > "Stephen M. Cameron" <scameron@beardog.cce.hp.com> wrote:
> > 
> > > Add hpsa driver for HP Smart Array controllers.
> > > 
> > > This driver supports a subset of HP Smart Array Controllers.
> > > It is a SCSI alternative to the cciss driver.
> > 
> > Does it support all the devices which cciss supports?
> > 
> > IOW, do we have a plan here to remove the cciss driver or must we
> > maintain both drivers indefinitely?
> 
> Andrew, et al.,
> >From the lack of response I'm guessing my reply about phasing cciss out
> completely did not go over well. Or is that what the question meant?
> 
> We purposely limited controller support in hpsa to try and prevent problems
> in the field. What's needed to get hpsa accepted? Add support for all
> hardware?
> 
> While we do not want to maintain 2 drivers indefinitely we (HP) must
> continue to support cciss for some years to come.
> 
> Any guidance is appreciated.
> 

Well, obviously it's neater if we can retire the old driver.  Sometimes
life isn't neat.  We had a similar situation with e1000-vs-e1000e.  And
with e100-vs-eepro100, although eepro100 went away after many years.


