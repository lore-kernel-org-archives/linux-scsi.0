From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Time to allow MODE SENSE for USB
	disk-typestorage de vices?
Date: 08 Mar 2004 14:16:11 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1078780571.18148.11.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0403081046190.1187-100000@ida.rowland.org>
	 <1078768520.2341.54.camel@patibmrh9>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:14293 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261220AbUCHVST
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 8 Mar 2004 16:18:19 -0500
In-Reply-To: <1078768520.2341.54.camel@patibmrh9>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: USB Storage List <usb-storage@lists.one-eyed-alien.net>, SCSI development list <linux-scsi@vger.kernel.org>

> > On a related note,

I wish I weren't hijacking your thread, but ...

> > we've run across reports from several users
> > indicating that their USB devices die when handed a PREVENT-ALLOW
> > MEDIUM REMOVAL command, even though they set the Removable-Medium flag
> > in their INQUIRY data.  Could there be a device flag that would cause
> > the sd driver to avoid these commands?
> 
> I hear op x1E Prevent/ Allow appears in Windows bus traces.
> 
> I wonder what cbw [or] sequence [of cbw's]
> avoids killing such devices for Windows.

I have NOT yet learned to trace all Linux cdb's, but ...

I happen to have an Atapi bus analyser connected just now ...

I see a Linux 2.6.4-rc2 host polling an Atapi RMB PDT x05 DVD/CD device
every two seconds with two -y "00 00:00:00 00 00" Test Unit Ready and
then one -y "1E 00:00:00 00 00" Allow.

This leads me to wonder if Linux is polling RMB PDT x00 with x1E Allow?

And if so, why???

Also does the USB dCBWDataLength for Linux x1E Allow differ from
Windows, since the Atapi BCL is, ugh, the zero that assumes Hn = Dn,
rather than the xFFFF and xFFFE Atapi BCL's said to be more massively
distributed.

Pat LaVarre


