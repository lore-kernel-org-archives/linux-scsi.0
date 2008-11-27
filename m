From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] SCSI: simplify scsi_io_completion()
Date: Wed, 26 Nov 2008 22:13:00 -0600
Message-ID: <1227759180.3387.61.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0811261830350.1675-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:32775 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752277AbYK0END (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Nov 2008 23:13:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.0811261830350.1675-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 2008-11-26 at 18:31 -0500, Alan Stern wrote:
> On Wed, 26 Nov 2008, James Bottomley wrote:
> 
> > > I was going to suggest adding a description to the ILLEGAL REQUEST
> > > case.  But that case arises normally under various circumstances, so
> > > perhaps it wouldn't be appropriate.  In fact, do you really want to
> > > print out the result and sense data every time that case occurs?
> > 
> > I think it's OK.  I thought some of the CD probing routines triggered
> > illegal requests, but I can't seem to see it on my test machines (it
> > could be I have the wrong type of CD, though).
> 
> So then it would make sense to add a description to that case as well.

Well, yes and no ... I can't see a description being much more
descriptive than what scsi_print_sense will already print ... mind you,
the same is true of volume overflow.  I'll remove that one.

James


