From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: ultrastor.c is a bit-rot
Date: Sun, 23 Mar 2008 10:18:46 -0700
Message-ID: <47E690F6.6030905@zytor.com>
References: <47DE8736.8020405@panasas.com> <20080317152344.GE26285@parisc-linux.org> <47E41D7D.9050409@zytor.com> <47E628DF.6070301@panasas.com> <47E68423.2010507@zytor.com> <20080323171652.GF10722@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from terminus.zytor.com ([198.137.202.10]:47993 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbYCWRYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 23 Mar 2008 13:24:21 -0400
In-Reply-To: <20080323171652.GF10722@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Boaz Harrosh <bharrosh@panasas.com>, Matthew Wilcox <matthew@wil.cx>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-kernel <linux-kernel@vger.kernel.org>

Al Viro wrote:
> 
> ... not that VLB didn't suck badly with several devices attached at the same
> time.  I would be rather surprised if that board would work if fully populated
> with VLB cards, all in active use.  IOW, a likely explanation is that it
> had a warning along the lines of "use of more than <number> of VLB cards
> at the same time may use instability" buried in documentation and proud
> "6 VLB slots!!!" touted by marketing...
> 
> I can't find VLB specs online, but IIRC 3 had been the limit and anything
> past that had been very much out of spec and likely to screw you.

I think that particular board had multiple root drivers (it was a P5 
board, so it wasn't a "local" bus anyway.)

	-hpa
