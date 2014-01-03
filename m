From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [RFC 0/2] target refcounting infrastructure fixes for usb
Date: Thu, 02 Jan 2014 16:34:31 -0800
Message-ID: <1388709271.2399.30.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:38714 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752709AbaACAed (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2014 19:34:33 -0500
In-Reply-To: <Pine.LNX.4.44L0.1312211547490.12252-100000@netrider.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>

On Sat, 2013-12-21 at 15:51 -0500, Alan Stern wrote:
> On Fri, 20 Dec 2013, Sarah Sharp wrote:
> 
> > On Thu, Dec 19, 2013 at 11:48:47AM -0800, James Bottomley wrote:
> > > It should apply incrementally on top of the previous two.  If it
> > > actually works, I'll fold it into the first patch.
> > 
> > Well, it doesn't oops anymore, but it does generate a pile of warnings:
> 
> This was a simple oversight.  scsi_target_reap() was called at the
> start of __scsi_remove_device(), but it should be called at the end.
> The patch below, applied on top of James's three patches, will fix the
> warnings.

Thanks, I'll do a repost of the combined series

> Alan Stern
> 
> P.S.: The comment isn't entirely correct any more...

Yes, fixed the tense.

James


