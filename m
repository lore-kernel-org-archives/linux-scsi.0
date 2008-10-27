From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 13:27:02 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0810271325470.2296-100000@iolanthe.rowland.org>
References: <1225127316.5146.32.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:45224 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751735AbYJ0R1D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Oct 2008 13:27:03 -0400
In-Reply-To: <1225127316.5146.32.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: =?ISO-8859-1?Q?=D6rjan?= Nordlund <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 27 Oct 2008, James Bottomley wrote:

> > > About the best we can do is check the first four fields.  For them to be
> > > all zero, it would have to be a minimal response SCSI-1 device (RDF of
> > > zero) ... hopefully they're all dead by now.
> > 
> > Then you're saying that the patch should everything up to
> > inq_result[8]?  Or maybe even beyond?  I can do that.  Would that be 
> > acceptable?
> 
> No ... "first four fields" means everything up to inq_result[3].
> Anything beyond that would be legitimately zero if they were.

But what about the case where the first four bytes are zero and some of 
the fields beyond them are nonzero.  Isn't that possible?

Alan Stern

