From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PATCH] final SCSI updates for 2.6.24 merge window
Date: Thu, 7 Feb 2008 19:11:33 -0800 (PST)
Message-ID: <alpine.LFD.1.00.0802071909350.2896@woody.linux-foundation.org>
References: <1202432206.3171.53.camel@localhost.localdomain> <20080207184606.03b28a9c.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:50888 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754324AbYBHDLh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 7 Feb 2008 22:11:37 -0500
In-Reply-To: <20080207184606.03b28a9c.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Nick Piggin <nickpiggin@yahoo.com.au>



On Thu, 7 Feb 2008, Andrew Morton wrote:
> 
> Sob.  Can we please merge "Convert SG from nopage to fault"?

Heh. I just took it directly then.

I think it's more of a VM patch than a SCSI patch anyway, so I don't think 
you really should even have tried to push it through the SCSI tree.

It's not like we ever do the low-level FS changes for VFS issues through 
the FS maintainers anyway (ie you sent me all those iget/read_inode things 
directly rather than trying to go through each filesystem). I don't think 
this is any different, really.

		Linus
