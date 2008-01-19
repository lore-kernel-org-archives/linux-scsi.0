From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/8] firewire: ieee1394: Move away from SG_ALL
Date: Sat, 19 Jan 2008 09:01:45 -0600
Message-ID: <1200754905.3136.4.camel@localhost.localdomain>
References: <478F8435.5000907@panasas.com> <478F854B.2030302@panasas.com>
	 <478F9596.1020509@s5r6.in-berlin.de>  <4791ADC9.7090207@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60280 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755760AbYASPBv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Jan 2008 10:01:51 -0500
In-Reply-To: <4791ADC9.7090207@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-scsi <linux-scsi@vger.kernel.org>


On Sat, 2008-01-19 at 08:59 +0100, Stefan Richter wrote:
> Stefan Richter wrote:
> > My guess is that there won't be conflicts of this with linux1394-2.6.git
> > anytime soon, so taking it into any other tree should be fine.
> 
> Wrong, there should already be a (trivial) conflict due to a patch from
> December.  Another (trivially) conflicting patch was sent to
> linux1394-devel a few hours ago.  Both patches will land in Linus' tree
> early during the next merge window.  So either refresh the patch when
> it's time, or give it to me.  (Whatever, try not to add to akpm's pain.)

Actually, I'm already tracking potential conflicts.  The
linux1394-2.6.git is part of the merge candidate tree I'm building
nightly.  These patches will go through the (now slightly misnamed)
scsi-bidi-2.6.git tree.  That one's built on top of all the currently
conflicting trees, and is scheduled to be the last thing merged in the
merge window (or at least to wait until the others its built on have
gone in).

James


