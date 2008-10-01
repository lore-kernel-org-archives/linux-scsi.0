From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: mac scsi, ncr5380
Date: Wed, 1 Oct 2008 17:19:54 +1000 (EST)
Message-ID: <Pine.LNX.4.64.0810011703120.13318@loopy.telegraphics.com.au>
References: <Pine.LNX.4.64.0809240019001.3458@loopy.telegraphics.com.au>
 <48DF8398.30000@panasas.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from loopy.telegraphics.com.au ([202.45.126.152]:37285 "EHLO
	loopy.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284AbYJAHT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 03:19:58 -0400
In-Reply-To: <48DF8398.30000@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, Sam Creasey <sammy@sammy.net>, Michael Schmitz <schmitz@biophys.uni-duesseldorf.de>, Christoph Hellwig <hch@infradead.org>



On Sun, 28 Sep 2008, Boaz Harrosh wrote:

> From what I understand, (And again I do not), the ESP sounds a lot like 
> the NCR5380. I would craft a very similar copy of the new ESP stack, 
> with it's central library and function-vector registration, The 
> scsi-generic part is all there, in full glory. Then one concentrated 
> effort should go into the basic/general chip programing, which lots of 
> it could be ripped from current code, and the different platform 
> implementation becomes one liners, if the new ESP stack is any 
> indication.

I still do not understand the whole ESP driver but when I wrote mac_esp.c 
I learned the value of the layered structure it provided.

I still have a lot to learn about the SCSI layers and the APIs too. I'm 
reading Documentation/scsi at the moment. If you know of any other 
introductory reading material, that would be a help.

> From my passed experience, there becomes a source code state when a 
> rewrite is less effort then any cleanup or enhancements. From the small 
> changes I had to do to the xxx_NCR5380 family of drivers, my guts 
> feeling scream "rewrite", so here I voice them. In the mid/long-term you 
> will work much less. And be much more satisfied from the results.

This makes sense. Thanks for your feedback.

Finn

> 
> Good lock
> Boaz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-m68k" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
