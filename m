From: "Andrew Vasquez" <andrew.vasquez@qlogic.com>
Subject: Re: SCSI Timeout issue w/ QLA2460
Date: Fri, 26 Sep 2003 11:36:29 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <B179AE41C1147041AA1121F44614F0B060ED2E@AVEXCH02.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [198.70.193.2] ([198.70.193.2]:30145 "EHLO AVEXCH01.qlogic.org")
	by vger.kernel.org with ESMTP id S261571AbTIZSgZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 26 Sep 2003 14:36:25 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: cworley@lnxi.com

Chris,

> Background: 2.4.21 korg kernel w/ Qlogic 2460 HBA and Qlogic's
> driver (modified for 4096 scatter-gather list size).  Eight servers
> are directly connected to a DDN S2A8000 SAN (dual controler, eight
> FC ports, 2GB file system), no FC switch.  

Just a couple of questions:

	o Which driver version are you refering to?  We'll need to
	  enable some debugging.

	o QLogic doesn't have a 2460 card (perhaps it was just a
	  typo).  What type of card do you have (2340/2342)?

Regards,
Andrew Vasquez
