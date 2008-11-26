From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/2] SCSI: simplify scsi_io_completion()
Date: Wed, 26 Nov 2008 18:31:28 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0811261830350.1675-100000@netrider.rowland.org>
References: <1227738589.3387.57.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:2545 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752606AbYKZXbc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Nov 2008 18:31:32 -0500
In-Reply-To: <1227738589.3387.57.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Wed, 26 Nov 2008, James Bottomley wrote:

> > I was going to suggest adding a description to the ILLEGAL REQUEST
> > case.  But that case arises normally under various circumstances, so
> > perhaps it wouldn't be appropriate.  In fact, do you really want to
> > print out the result and sense data every time that case occurs?
> 
> I think it's OK.  I thought some of the CD probing routines triggered
> illegal requests, but I can't seem to see it on my test machines (it
> could be I have the wrong type of CD, though).

So then it would make sense to add a description to that case as well.

Alan Stern

