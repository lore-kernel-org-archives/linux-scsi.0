From: Jing Huang <huangj@Brocade.COM>
Subject: RE: [PATCH 0/7] bfa: update bfa driver to version 2.1.2.1
Date: Fri, 20 Nov 2009 09:40:25 -0800
Message-ID: <04391A4E90BB2149B010D22452FA168702063371@HQ-EXCH-6.corp.brocade.com>
References: <1258675713-17487-1-git-send-email-huangj@brocade.com>
	 <1258688102.6363.722.camel@mulgrave.site>
	 <04391A4E90BB2149B010D22452FA168702063351@HQ-EXCH-6.corp.brocade.com>
 <1258729830.2889.134.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hq-exedge.brocade.com ([66.243.153.82]:32121 "EHLO
	hq-exedge.brocade.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753512AbZKTRk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2009 12:40:26 -0500
In-Reply-To: <1258729830.2889.134.camel@mulgrave.site>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Adapter Linux Open SRC Team <adapter_linux_open_src_team@Brocade.COM>

> > Sorry about the terse description. This patch set basically updates
> > the current driver in scsi-misc-2.6 to our recently released 2.1
> > driver. We couldn't make it in upstream in our initial submission
> > since it was not ready at that time. Except for the second item (2
> > fixes received from upstream, which you already added into rc fix tree
> > but not in scsi-misc-2.6), the remaining changes come from our
> > internal 2.1 GA driver which is intended to be included in 2.6.33
> > merge window. I divide them into 7 patches for the consideration of
> > patch size. Moving forward, we will make incremental changes instead
> > of big patches like this.
> 
> OK, so the fixes already in rc-fixes (and now upstream) can't go
> separately into scsi-misc as part of other patches otherwise we'll get a
> nasty merge conflict in linux-next (and later linus' tree at the merge
> window) since rc-fixes is already upstream.
> 

This makes sense. I will not include them in my resubmission.

> So base the patch off a combination of linus' upstream tree and
> scsi-misc (just pull one tree into another) and I'll sort out the
> prerequisites on this end (just mention it needs patches in linus and
> not in scsi-misc).
> 

Will do this to create the patch for resubmission.

> If you could do it, the enterprise distributions would very  much
> appreciate code clean up separated from bug fixes ... with a nice
> description of the bugs actually fixed so they know what to do if bugs
> come in to them.
> 
> James
> 

I will come up a detailed description of the issues we fixed in 2.1 driver and resubmit.

Thanks

Jing
