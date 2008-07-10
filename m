From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: erase invalid data returned by device
Date: Thu, 10 Jul 2008 18:28:45 -0500
Message-ID: <1215732525.3353.102.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0806241402020.2166-100000@iolanthe.rowland.org>
	 <Pine.LNX.4.64.0807101908390.1756@lancer.cnet.absolutedigital.net>
	 <alpine.LFD.1.10.0807101623070.2936@woody.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:41014 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345AbYGJX2t (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Jul 2008 19:28:49 -0400
In-Reply-To: <alpine.LFD.1.10.0807101623070.2936@woody.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Cal Peake <cp@absolutedigital.net>, Alan Stern <stern@rowland.harvard.edu>, Peter Teoh <htmldeveloper@gmail.com>, Maciej Rutecki <maciej.rutecki@gmail.com>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>

On Thu, 2008-07-10 at 16:23 -0700, Linus Torvalds wrote:
> 
> On Thu, 10 Jul 2008, Cal Peake wrote:
> > 
> > It looks like we're getting down to the last -rc; can this patch please 
> > make it into main-line before 2.6.26 goes final?
> 
> James said he was pushing it out to his scsi-rc-fixes tree, but I haven't 
> seen a pull request.
> 
> But you're right, final is near. Maybe I should just merge it directly.

It's one of the two patches in scsi-rc-fixes.  I'm just seeing if any
problems show up in linux-next.  I'm playing the usual game of trying to
judge how long I have left ... so I'm thinking on Monday ... is that
about right?

James


