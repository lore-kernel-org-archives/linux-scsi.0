From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as373) Let LLD specify INQUIRY length
Date: Fri, 15 Oct 2004 14:30:59 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0410151426180.1052-100000@ida.rowland.org>
References: <20040826201128.A23103@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:25348 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S268275AbUJOSa7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Oct 2004 14:30:59 -0400
In-Reply-To: <20040826201128.A23103@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 26 Aug 2004, Christoph Hellwig wrote:

> Maybe instead of adding gazillions of blacklists for different inquiry
> lengthes we should just add an max_inquiry_length field to scsi_device
> that can be set in slave_alloc?

Christoph:

I sent in a patch to do this:

http://marc.theaimsgroup.com/?l=linux-scsi&m=109459028822709&w=2

Nobody has responded to it.  Is there some particular person I should send
this to?  Or should I change the patch, so that it merely addresses the
issue at hand without simplifying the entire subroutine?

Alan Stern

