From: Matt Gulick <gulickconsulting@direcway.com>
Subject: Re: bug 2400
Date: Thu, 01 Apr 2004 16:53:20 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080860000.5300.60.camel@localhost.localdomain>
References: <20040401131502.41136788.akpm@osdl.org>
 <1080856352.5300.43.camel@localhost.localdomain>
 <1080859235.2117.61.camel@mulgrave>
Reply-To: gulickconsulting@direcway.com
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from a34-mta01.direcpc.com ([66.82.4.90]:54383 "EHLO
	a34-mta01.direcway.com") by vger.kernel.org with ESMTP
	id S263229AbUDAWxp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Apr 2004 17:53:45 -0500
Received: from [40.0.0.57] (dpc6935101125.direcpc.com [69.35.101.125])
 by a34-mta01.direcway.com
 (iPlanet Messaging Server 5.2 HotFix 1.12 (built Feb 13 2003))
 with ESMTP id <0HVI003BEKX3O8@a34-mta01.direcway.com> for
 linux-scsi@vger.kernel.org; Thu, 01 Apr 2004 17:53:44 -0500 (EST)
In-reply-to: <1080859235.2117.61.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andrew Morton <akpm@osdl.org>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2004-04-01 at 16:40, James Bottomley wrote:
> On Thu, 2004-04-01 at 16:52, Matt Gulick wrote:
> > Where you will get into trouble is that SCSI is not considered to be
> a
> > 'Dynamic' bus.  Devices do not normally come and go, while USB and
> 1394
> > devices are 'Hot Plugable'.
> 
> It isn't? considering all the refcounting work that's gone into the
> SCSI
> stack to make it support hotplug transports, I don't think such a
> blanket statement is supportable.
> 
> James

James,

You may be right.  I have not fully dissected the Linux SCSI stack.  I
am very intimately familiar with the Darwin SCSI stack as well as the
Windose stacks (I had to fully architect USB 2.0 stack with support for
SBP-2 under SE, ME and 2k, [I feel so dirty]).

The Linux stack may be more forward looking.

Matt

----------------------------------------
Matt Gulick
Sr. Staff Engineer
Adaptec, Inc.
gulickconsulting@direcway.com
matt_gulick@adaptec.com
(715) 426-0884


