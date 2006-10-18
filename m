From: Mark Haverkamp <markh@osdl.org>
Subject: Re: kernel oops with aacraid 1.1-5[2409]-mh1 under
	2.6.17-1.2187_FC5
Date: Wed, 18 Oct 2006 10:42:11 -0700
Message-ID: <1161193331.15307.11.camel@markh3.pdx.osdl.net>
References: <20061018163357.GG1243@dot.oreally.co.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:46299 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751507AbWJRRmU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Oct 2006 13:42:20 -0400
In-Reply-To: <20061018163357.GG1243@dot.oreally.co.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin Keith <linux-scsi@ckeith.clara.net>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-10-18 at 17:33 +0100, Colin Keith wrote:
> Hi,
> 
> I've been having a major problem with a box containing an adaptec
> ASR-2130SLP scsi raid card randomly crashing. As more users were added
> to the box it has gotten worse to the point where the uptime could be
> in the order of hours. I've managed to snag the kernel oops a couple of
> times and a copy of one is provided below (it always crashes in the same
> place).
> 
> I've seen one other person post this exact same oops output but I saw no
> responses. I've tried a number of different fixes including upgrading to
> the Fedora provided 2.6.18-1.2200 kernel which uses 1-1.5[2409]-mh2.  This
> has been running for 12 hours, but as the crashes are intermittent its hard
> to know if this resolves it as yet, but I'm concerned that it won't. I've
> tried various different kernels (including using the wonderful 2.6.17-1.2157
> which thanks to the XFS bugs was secretly trashing my FS each time it
> crashed and 2.6.17-1.2174 which stayed up 5 minutes before triggering this
> bug).

There was a patch checked in that removed some un-needed list_head
elements post 2.6.17.   I believe that there were reports of list
corruption problems that this patch solved.  The 2.6.18-1.2200-fc5 has
this patch.


> 
> 
-- 
Mark Haverkamp <markh@osdl.org>

