From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [GIT PATCH] final SCSI pieces for the merge window
Date: Wed, 24 Oct 2007 09:28:10 -0400
Message-ID: <1193232490.3396.10.camel@localhost.localdomain>
References: <471E6313.1040704@garzik.org>
	 <1193174424.3434.3.camel@localhost.localdomain>
	 <471E707B.1020505@garzik.org>
	 <20071023.153635.21595587.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:45678 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752859AbXJXN2O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Oct 2007 09:28:14 -0400
In-Reply-To: <20071023.153635.21595587.davem@davemloft.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Miller <davem@davemloft.net>
Cc: jeff@garzik.org, akpm@linux-foundation.org, torvalds@linux-foundation.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2007-10-23 at 15:36 -0700, David Miller wrote:
> From: Jeff Garzik <jeff@garzik.org>
> Date: Tue, 23 Oct 2007 18:06:51 -0400
> 
> > James Bottomley wrote:
> > > On Tue, 2007-10-23 at 17:09 -0400, Jeff Garzik wrote:
> > >> James Bottomley wrote:
> > >>> This should be the final SCSI updates; it's mainly just a few accessor
> > >>> completion updates and two driver merges (sym2 and qla2xxx) we also
> > >>> secured DaveM's agreement to remove fcal/fc4, which explains the high
> > >>> removal line count.
> > >>>
> > >>> The patch is available here:
> > >>>
> > >>> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git
> > >> I guess I have the go-ahead to merge the end-CDROM-polling async 
> > >> notification work you've been repeatedly ignoring?
> > > 
> > > I haven't been ignoring it ... it just needs quite a bit of work; the
> > > best way to accelerate it seems to be simply to do it (add the
> > > supported/trigger event bitmasks and expand the infrastructure).  I just
> > > haven't had the time within the merge window.
> > 
> > James, things cannot get bottlenecked like this.  You have had MONTHS to 
> > say something like this.  The code was ready BEFORE the merge window.
> > 
> > I really think you have the knowledge to be SCSI maintainer, but not the 
> > time.
> 
> Unfortunately, I think this is an important point.
> 
> Developers depend strongly upon a subsystem maintainer to
> "make time" for these things so that work integration does
> not get delayed past the merge window if at all possible.
> 
> Not being able to "make time" to do these things is a great
> way to lose contributers.
> 
> James, whilst there is no doubt in my mind that skill-wise
> you are probably the most capable scsi maintainer, your "lack
> of time" is sounding like a broken record and harming the
> development process.

OK, so it's no secret that I'm the last of the subsystem maintainers
whose day job isn't working on the linux kernel.  If you want a full
time person, who did you have in mind?

James


