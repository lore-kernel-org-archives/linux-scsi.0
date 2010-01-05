From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 3/3 version 4] scsi_lib: Collapse scsi_end_request into
 only user
Date: Tue, 5 Jan 2010 11:33:39 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.1001051130540.3002-100000@iolanthe.rowland.org>
References: <4B43679C.9090009@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:56258 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753816Ab0AEQdl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Jan 2010 11:33:41 -0500
In-Reply-To: <4B43679C.9090009@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 5 Jan 2010, Boaz Harrosh wrote:

> On 01/05/2010 05:20 PM, Alan Stern wrote:
> > On Tue, 5 Jan 2010, Boaz Harrosh wrote:
> > 
> >> Embedding scsi_end_request() into scsi_io_completion actually simplifies
> >> the code and makes it clearer what's going on.
> >>
> >> There is absolutely no functional and/or side effects changes after this
> >> patch.
> > 
> > Here are some suggestions for changes to the comments.  These are quite
> > minor and you might not want to bother updating the patch yet again...
> > 
> 
> Sure, NP. thanks for checking me out, coming from Hebrew I do need support
> in these matters. Will update tomorrow.
> 
> Alan can I add your Review-by: this time around?

Yes.  This is a good step.  It will make adding functional changes a 
lot easier, and it will help if anyone wants to split up
scsi_io_completion() into several smaller routines.

Alan Stern

