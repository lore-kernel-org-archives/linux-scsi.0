From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [patch 10/12] lkdtm: fix for CONFIG_SCSI=n
Date: Wed, 30 Jul 2008 22:55:43 +0200
Message-ID: <20080730205543.GA17429@uranus.ravnborg.org>
References: <200807301944.m6UJiSab012906@imap1.linux-foundation.org> <1217449008.3335.39.camel@localhost.localdomain> <20080730134243.d2b9894b.akpm@linux-foundation.org> <1217450846.3335.46.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtpout3.tre.se ([80.251.192.228]:20338 "EHLO smtpout3.tre.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756074AbYG3Uzp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Jul 2008 16:55:45 -0400
Content-Disposition: inline
In-Reply-To: <1217450846.3335.46.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, ankita@in.ibm.com

> 
> I assumed it was a piece of something I didn't have but which would
> appear in mainline after the merge window opened.  Now the merge window
> has opened and closed ...
> 
> > >  There's
> > > no tests directory in any kernel tree I have.
> > 
> > You don't have a copy of linux-next?  Wow.
> 
> Erm .. what is it that was in linux-next before 2.6.26 and still isn't
> in mainline?  Isn't that a linux-next protocol violation?
The pull request was sent late and ignored.

> 
> > I'll send it to Sam.
> 
> If he has the unmerged tree for this, sure.
I do.

	Sam
