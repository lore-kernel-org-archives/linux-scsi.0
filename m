From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] SCSI: detect missing data for INQUIRY
Date: Mon, 27 Oct 2008 12:29:33 -0500
Message-ID: <1225128573.5146.34.camel@localhost.localdomain>
References: <Pine.LNX.4.44L0.0810271325470.2296-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:47529 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751379AbYJ0R3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Oct 2008 13:29:38 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810271325470.2296-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: =?ISO-8859-1?Q?=D6rjan?= Nordlund <orjan.nordlund@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 2008-10-27 at 13:27 -0400, Alan Stern wrote:
> On Mon, 27 Oct 2008, James Bottomley wrote:
> 
> > > > About the best we can do is check the first four fields.  For them to be
> > > > all zero, it would have to be a minimal response SCSI-1 device (RDF of
> > > > zero) ... hopefully they're all dead by now.
> > > 
> > > Then you're saying that the patch should everything up to
> > > inq_result[8]?  Or maybe even beyond?  I can do that.  Would that be 
> > > acceptable?
> > 
> > No ... "first four fields" means everything up to inq_result[3].
> > Anything beyond that would be legitimately zero if they were.
> 
> But what about the case where the first four bytes are zero and some of 
> the fields beyond them are nonzero.  Isn't that possible?

Not if the device conforms to the standard.

James


