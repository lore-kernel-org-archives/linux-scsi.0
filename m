From: Nathan Bryant <nbryant@optonline.net>
Subject: Re: Suspending SCSI devices and buses
Date: Fri, 20 Aug 2004 18:32:07 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41267BE7.20502@optonline.net>
References: <7C828B3E-F2EA-11D8-B9BF-00039398BB5E@ieee.org>
 <"41266F71.906020 7"@optonline.net>
 <31E92B97-F2F5-11D8-8CAE-00039398BB5E@ieee.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta7.srv.hcvlny.cv.net ([167.206.5.74]:53459 "EHLO
	mta7.srv.hcvlny.cv.net") by vger.kernel.org with ESMTP
	id S268783AbUHTWcI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Aug 2004 18:32:08 -0400
Received: from [67.86.72.128] (ool-43564880.dyn.optonline.net [67.86.72.128])
 by mta7.srv.hcvlny.cv.net
 (iPlanet Messaging Server 5.2 HotFix 1.25 (built Mar  3 2004))
 with ESMTP id <0I2R00L33NXJMP@mta7.srv.hcvlny.cv.net> for
 linux-scsi@vger.kernel.org; Fri, 20 Aug 2004 18:32:07 -0400 (EDT)
In-reply-to: <31E92B97-F2F5-11D8-8CAE-00039398BB5E@ieee.org>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>

Pat LaVarre wrote:

>> S3
>
>
> I know this is popular PC jargon, I don't personally know what it means.

ACPI suspend-to-RAM. Power is cut to almost everything except RAM and 
wakeup event circuitry, some PCI slots may be left in D3hot with wake 
events enabled. Motherboard signals the ATX power supply to cut power to 
all the peripheral connectors.

It's very similar to powerdown with the RAM refresh turned on.

Nathan
