From: Christoph Hellwig <hch@infradead.org>
Subject: Re: Large disk drives
Date: Wed, 5 Nov 2014 11:30:45 -0800
Message-ID: <20141105193045.GA13265@infradead.org>
References: <1415203668.13212.2.camel@jarvis>
 <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:42619 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081AbaKETau (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2014 14:30:50 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1411051130470.1531-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Dale R. Worley" <worley@alum.mit.edu>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

On Wed, Nov 05, 2014 at 11:34:11AM -0500, Alan Stern wrote:
> > Sorry, meant to.  In principle I'm OK with this as the lever for the
> > hack (largely because it means we don't need to do anything) but will
> > the distributions support it?
> 
> While I can't speak for the distributions, it's reasonable to assume 
> that if something becomes part of the upstream kernel then they will 
> include it.

Btw, we do have precedence for looking at partition tables from SCSI
code with scsi_partsize(), so the layering violation of looking at
EFI labels for disks sizes wouldn't be something entirely new even
if we did it in kernel space.
