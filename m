From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 16:44:09 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068767049.2851.166.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:14481 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264457AbTKMXol
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 18:44:41 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

Alan S:

> > > > We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink at
> > > > the same time we fix SCSI over USB, yes?
> > > 
> > > Are they broken?
> > 
> > Aye, in much the same way: nothing but Talk Like Windows actually works
> > well ...
>
> Those sound like different issues from the one we've been discussing in 
> this thread, namely: how should sd.c try to determine the read/write 
> status and cache-type of a disk device?

I mean to be saying sd.c should by default send the CDB's associated
with buffer lengths that produce the same BBB CBW's as Windows XP/2K,
and then determine the read/write status and cache-type from that info
alone.

Do you agree that works for generic USB storage i.e. bInterfaceClass
...SubClass ...Protocol = x 08 (02|05|06) 50?

Do you disagree that is what we should do in sd for generic USB storage?

I'm confident Win XP/2K sometimes sends mode select to PDT x00
HDD/Flash, because I remember some months back a friend fixed some
firmware that didn't interpret mode select like Win wants nowadays.

I imagine that means Win sends mode sense too.

I haven't yet seen a trace of Win XP/2K.

Pat LaVarre


