From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: bug 2400
Date: Thu, 01 Apr 2004 16:48:08 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080859687.5300.54.camel@localhost.localdomain>
References: <20040401131502.41136788.akpm@osdl.org>
 <1080856352.5300.43.camel@localhost.localdomain>
 <20040401140801.364bcbb1.akpm@osdl.org>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:26472 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S262931AbUDAWsW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 17:48:22 -0500
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVI004Y3KO8AW@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 01 Apr 2004 17:48:21 -0500 (EST)
In-reply-to: <20040401140801.364bcbb1.akpm@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Thu, 2004-04-01 at 16:08, Andrew Morton wrote:
> Matt Gulick <gulickconsulting@direcway.com> wrote:
> >
> > Remember, SCSI is not hot plugable.
> 
> oopsing the kernel is not a particularly friendly way of telling this
> to
> our users.
> 
> If we have to bandaid over this, say, by leaking some memory and
> emitting
> some rude printk's then OK.  Allowing the machine to kill itself,
> potentially losing all the user's unsaved work is distinctly windows
> 95ish,
> and is not OK, agree?
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Very true.  Oopsing the kernel is never good.(the BSOD is my favorite
screen though, when a PC crashes and my iBook chugs along)

The thing to do is to run through a clean-up proc when this happens. 
This is also why I use multiple ptrs in my code.  The structures would
then be torn down and released.  An alert might also be generated to
inform the user that the device was not properly removed which could
result in data loss.

Anything is better than an Oops.

I would volunteer to take this on but I am between jobs at the moment
and would not want to start something that I did not have time to
properly complete.  I will look at it and see if I have any suggestions
for whoever takes this on.

Matt
 
----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


