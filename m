From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC] Pass information about device open/close to low-level
 driver
Date: Mon, 26 Sep 2011 21:39:07 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1109262134130.29772-100000@netrider.rowland.org>
References: <20110926201216.GA18666@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netrider.rowland.org ([192.131.102.5]:34212 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751373Ab1I0BjJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2011 21:39:09 -0400
In-Reply-To: <20110926201216.GA18666@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Tejun Heo <htejun@gmail.com>, Hans de Goede <hdegoede@redhat.com>, SCSI development list <linux-scsi@vger.kernel.org>

[Sorry for using an old email address for James -- fixed now.]

On Mon, 26 Sep 2011, Christoph Hellwig wrote:

> On Mon, Sep 26, 2011 at 04:10:32PM -0400, Alan Stern wrote:
> > James:
> > 
> > Something like the patch below has been requested by the virtualization
> > people.
> 
> Who are "the virtualization people"?

In this case, Hans de Goede and other people he is in contact with at 
VMware.  He can provide further details.

> Either way this idea is a really bad one, and if you check history long
> enough you'd notice we had all that crap in kernel before 2.6 and got
> rid of it all.

Sorry, I don't have enough time to wade through hundreds of megabytes
of kernel history to sort this out.

Can you list any specific objections?  Or suggest an alternative 
strategy to accomplish the same result?

Alan Stern

