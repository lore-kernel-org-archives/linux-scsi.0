From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: PATCH: (as284c) Add BLIST_INQUIRY_36 to all USB blacklist entries
Date: Thu, 26 Aug 2004 15:27:03 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0408261525300.1089-100000@ida.rowland.org>
References: <20040826201128.A23103@infradead.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:44036 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S269503AbUHZT1I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Aug 2004 15:27:08 -0400
In-Reply-To: <20040826201128.A23103@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 26 Aug 2004, Christoph Hellwig wrote:

> On Thu, Aug 26, 2004 at 11:53:45AM -0400, Alan Stern wrote:
> > James:
> > 
> > I submitted this patch earlier but received no response.
> > 
> > This patch adds the BLIST_INQUIRY_36 flag to all the SCSI blacklist
> 
> Maybe instead of adding gazillions of blacklists for different inquiry
> lengthes we should just add an max_inquiry_length field to scsi_device
> that can be set in slave_alloc?

That sounds good to me.  The usb-storage driver sets BLIST_INQUIRY_36 in 
slave_alloc(), but an existing blacklist entry will override it.

Alan Stern

