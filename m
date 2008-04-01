From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 10374] New: sym53c8xx: weird behavior with
	udev
Date: Tue, 01 Apr 2008 16:14:14 -0500
Message-ID: <1207084454.3100.31.camel@localhost.localdomain>
References: <bug-10374-10286@http.bugzilla.kernel.org/>
	 <20080401011518.eb683cff.akpm@linux-foundation.org>
	 <1207059115.3100.9.camel@localhost.localdomain>
	 <20080401210521.abbb443c.seraph@xs4all.nl>
	 <1207081169.3100.20.camel@localhost.localdomain>
	 <20080401225717.7d936f91.seraph@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:37023 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761936AbYDAVOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Apr 2008 17:14:19 -0400
In-Reply-To: <20080401225717.7d936f91.seraph@xs4all.nl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jos van der Ende <seraph@xs4all.nl>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, bugme-daemon@bugzilla.kernel.org

On Tue, 2008-04-01 at 22:57 +0200, Jos van der Ende wrote:
> On Tue, 01 Apr 2008 15:19:29 -0500
> James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> 
> > That's odd ... it's behaving like a resource conflict.  However, the
> > ports and interrupt trace didn't betray anything.  What does lspci -vv
> > say for each of the devices?
> 
> Output from lspci -vv attached.

Thanks ... unfortunately looks normal too.  The gem has a single memory
region; the sym2 has 2 mem and one IO region, all of which show up in
the /proc/iomem|ports.

> > Also, if you remove the sym2 module in the
> > problem case, does the sungem come back to life?
> 
> No, once it is hosed it stays hosed until the next boot. Fiddling with the wrong ioports maybe?

Yes ... that's what I guess.  Just as one last grasp at a straw, is
there any difference in /proc/iomem or /proc/ioports for the working
case (sungem loaded first followed by sym2)?

> > I'm afraid I can't see anything relevant looking over the sym2 changes,
> > so you might need to bisect this to identify the culprit.
> 
> Working on that, but it is a hassle as this bitty-box needs some time to compile a kernel. 2.6.23-rc1 didn't boot, for starters.

Sorry ... can't think of much else that will help.

James


