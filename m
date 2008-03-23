From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: ultrastor.c is a bit-rot
Date: Sun, 23 Mar 2008 17:16:52 +0000
Message-ID: <20080323171652.GF10722@ZenIV.linux.org.uk>
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com> <47E628DF.6070301@panasas.com> <47E68423.2010507@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:37654 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752257AbYCWRRn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2008 13:17:43 -0400
Content-Disposition: inline
In-Reply-To: <47E68423.2010507@zytor.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Sun, Mar 23, 2008 at 09:24:03AM -0700, H. Peter Anvin wrote:

> >Hmm interesting, so someone took the VGA thing and made a storage device
> >for it. Did that ever happen with AGP? Any AGP scsi cards. I guess I can
> >Google for it.
> 
> A lot less likely, IMO.  Unlike AGP-PCI, VLB slots were compatible with 
> ISA cards, and the electricals were less complex, so several motherboard 
> manufacturers built boards with 3 or more VESA slots (I think I saw a 
> board with 6 at one point.)
> 
> AGP electricals pretty much require that it be point to point.

... not that VLB didn't suck badly with several devices attached at the same
time.  I would be rather surprised if that board would work if fully populated
with VLB cards, all in active use.  IOW, a likely explanation is that it
had a warning along the lines of "use of more than <number> of VLB cards
at the same time may use instability" buried in documentation and proud
"6 VLB slots!!!" touted by marketing...

I can't find VLB specs online, but IIRC 3 had been the limit and anything
past that had been very much out of spec and likely to screw you.
