From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 2/2] relax scsi dma alignment
Date: Tue, 1 Jan 2008 11:35:32 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0801011132500.9875-100000@netrider.rowland.org>
References: <1199203210.3252.2.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:4858 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756061AbYAAQfe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jan 2008 11:35:34 -0500
In-Reply-To: <1199203210.3252.2.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Kristian Hoegsberg <krh@bitplanet.net>

On Tue, 1 Jan 2008, James Bottomley wrote:

> On Mon, 2007-12-31 at 17:57 -0500, Alan Stern wrote:

> > It would be better to move the existing code from the start of
> > slave_configure() up into slave_alloc().  Otherwise it's fine.
> 
> Um, yes, you're right, I didn't notice there was an existing one ... I
> just assumed you were relying on the SCSI default.
> 
> Here's an updated patch.
> 
> James

If I had put the alignment call in the correct place to begin with, 
this change wouldn't be needed.  Ah well...

Acked-by: Alan Stern <stern@rowland.harvard.edu>

