From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: usb storage traces
Date: 05 Dec 2003 13:27:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070656037.12411.542.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051421160.645-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:23963 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264368AbTLEU13
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 15:27:29 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312051421160.645-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org

> > If so, then we can say msft turns write-behind etc. on when the drive is
> > hot-pluggable, but turns write-behind etc. off when the disk is fully
> > hot-pluggable or even only hot-pluggable while not prevented.  Not good
> > policy, though too late now I suppose.
> 
> Be careful with your nomenclature.  Hot-pluggable and removable-media are 
> two different things.

Sorry I was unclear.  I mean to say Four things:

a) Write-behind risks more if people commonly do yank the device cable
or the disk itself while an fs of the disk is mounted.

b) Here we may be seeing msft choose to reduce thruput by turning off
write-behind while still shattering streams into just a few bytes/cdb.

c) Here we may be seeing msft making this choice whenever the device
sets op x12 Inquiry bytes[1] & x80 RMB to say the disk can unplug
without the drive unplugging.

d) Massively distributing host silliness like that provokes silliness in
device design.  Give an advantage to devices that don't say the disk can
unplug without the drive unplugging, and more devices will learn to
electronically unplug the drive when the disk unplugs.

Is my jargon still wrong?  Am I still unclear?  If I have failed again
might you tell me?

Pat LaVarre


