From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.27-rc1
Date: Mon, 04 Aug 2008 09:44:52 -0500
Message-ID: <1217861092.3318.10.camel@localhost.localdomain>
References: <1217800985.4179.55.camel@localhost.localdomain>
	 <20080804142927.GG8301@fluff.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:52528 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753359AbYHDOo7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Aug 2008 10:44:59 -0400
In-Reply-To: <20080804142927.GG8301@fluff.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ben Dooks <ben-linux@fluff.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Mon, 2008-08-04 at 15:29 +0100, Ben Dooks wrote:
> On Sun, Aug 03, 2008 at 05:03:05PM -0500, James Bottomley wrote:
> > This is just a small selection of four fixes, one expanding driver
> > bindings and the other three fixing actual bugs (all of which need
> > backporting to 2.6.26 I'm afraid).
> > 
> > The patch is available here:
> > 
> > master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> > 
> > The short changelog is:
> > 
> > HighPoint Linux Team (1):
> 
> I thought group (or non-person) submissions where explicitly
> prohibitted in the signoff section in Documentation/SubmittingPatches

Not as I read it.  It says:

        then you just add a line saying
        
                Signed-off-by: Random J Developer
        <random@developer.example.org>
        
        using your real name (sorry, no pseudonyms or anonymous
        contributions.)
        
Which doesn't preclude company signoffs (as long as it's a real
company).  Of course, most companies worry about the legal liability
from the GPL and the DCO, which is why we get so few of them.

James


