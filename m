From: James Bottomley <James.Bottomley@suse.de>
Subject: RE: [PATCH 0/7] bfa: update bfa driver to version 2.1.2.1
Date: Fri, 20 Nov 2009 10:10:30 -0500
Message-ID: <1258729830.2889.134.camel@mulgrave.site>
References: <1258675713-17487-1-git-send-email-huangj@brocade.com>
	 <1258688102.6363.722.camel@mulgrave.site>
	 <04391A4E90BB2149B010D22452FA168702063351@HQ-EXCH-6.corp.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:34671 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814AbZKTPK2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2009 10:10:28 -0500
In-Reply-To: <04391A4E90BB2149B010D22452FA168702063351@HQ-EXCH-6.corp.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@Brocade.COM>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

On Thu, 2009-11-19 at 21:39 -0800, Jing Huang wrote:
> > > This patch set updates bfa driver to version 2.1.2.1. It contains:
> > >
> > > - Bugs fixes from latest internal release (bfa driver version 2.1.0.0)
> > > - Bug fixes received from upstream.
> > > - Misc code cleanups & reorganization.
> > 
> > This description is incredibly terse.
> > 
> > Then seven patches with the only description as patch 1 through patch 7
> > isn't really on.
> > 
> > It looks like from the above, you actually have three separate patches,
> > two of which might need copying to stable ... if so, three patches with
> > accurate descriptions would be gratefully accepted.
> > 
> > Thanks,
> > 
> > James
> > 
> 
> James,
> 
> Sorry about the terse description. This patch set basically updates
> the current driver in scsi-misc-2.6 to our recently released 2.1
> driver. We couldn't make it in upstream in our initial submission
> since it was not ready at that time. Except for the second item (2
> fixes received from upstream, which you already added into rc fix tree
> but not in scsi-misc-2.6), the remaining changes come from our
> internal 2.1 GA driver which is intended to be included in 2.6.33
> merge window. I divide them into 7 patches for the consideration of
> patch size. Moving forward, we will make incremental changes instead
> of big patches like this.

OK, so the fixes already in rc-fixes (and now upstream) can't go
separately into scsi-misc as part of other patches otherwise we'll get a
nasty merge conflict in linux-next (and later linus' tree at the merge
window) since rc-fixes is already upstream.

So base the patch off a combination of linus' upstream tree and
scsi-misc (just pull one tree into another) and I'll sort out the
prerequisites on this end (just mention it needs patches in linus and
not in scsi-misc).

If you could do it, the enterprise distributions would very  much
appreciate code clean up separated from bug fixes ... with a nice
description of the bugs actually fixed so they know what to do if bugs
come in to them.

James


