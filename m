From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH] SCSI: sanitize INQUIRY strings
Date: Mon, 21 Aug 2006 12:52:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0608211248490.8319-100000@iolanthe.rowland.org>
References: <20060821161417.GB4340@parisc-linux.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:9994 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1422703AbWHUQwS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Aug 2006 12:52:18 -0400
In-Reply-To: <20060821161417.GB4340@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

On Mon, 21 Aug 2006, Matthew Wilcox wrote:

> On Mon, Aug 21, 2006 at 12:03:21PM -0400, Alan Stern wrote:
> > This patch (as766) sanitizes the Vendor, Product, and Revision strings
> > contained in an INQUIRY result, by setting all non-graphic or
> > non-ASCII characters to ' '.  Since the standard disallows such
> > characters, this will affect only non-compliant devices.
> 
> I thiink you attached the wrong patch; it doesn't match the description
> at all.

No; it does match the description.  But you have to read it carefully, 
because the majority of the patch implements optimizations made possible 
by the small piece that does the actual sanitizing.

>  Besides, print_inquiry is gone in scsi-misc.

The patch was based on 2.6.18-rc4.  Is there a patch file I can download 
with the differences between that kernel and the current SCSI development 
tree?

Alan Stern

