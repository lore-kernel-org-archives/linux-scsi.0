From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 31 Oct 2003 13:47:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1067633246.5742.49.camel@patrh9>
References: <Pine.LNX.4.44L0.0310301457300.1440-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:22668 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263545AbTJaUrw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 31 Oct 2003 15:47:52 -0500
In-Reply-To: <Pine.LNX.4.44L0.0310301457300.1440-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: patmans@us.ibm.com, ronald@kuetemeier.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, james.bottomley@steeleye.com

> > > I am very doubtful that this will work, or rather that it will work with
> > > all devices.  I've seen _lots_ of reports of USB devices that can't handle
> > > page 8, with all sorts of combinations of values for len attempted.
> > 
> > Are we confident that back then we tried the Win value for len?
> > 
> > Are we confident the Win value is x1C = header + optional block
> > descriptor + page?
> 
> Not at all.  You mentioned that it might be because you had seen it in a 
> trace posted not long ago.  But I think that was a trace from a Linux 
> host, not a Windows host.  Anyway, as you can see from Ronald's most 
> recent test, using that request didn't work with his device.

I'm still struggling to reconcile your history of pain with mine.

I find this particular statement slightly too broad to include me.

I agree we know Ronald's CB device choked over what we gave it.  I don't
yet know if Ronald's device didn't like bits of the CDB, bits of the CDB
length, both, or something else.

> I don't know what Windows does.  I've heard rumors that it determines 
> whether the drive is writable by actually trying to write a block and 
> checking to see if the write worked.

Me too.

Pat LaVarre


