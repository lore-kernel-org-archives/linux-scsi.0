From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: READ_CAPACITY_16 vs. READ_CAPACITY_10
Date: Tue, 10 Sep 2013 13:25:52 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1309101322390.1075-100000@iolanthe.rowland.org>
References: <1378821408.13541.26.camel@linux-fkkt.site>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:42025 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752411Ab3IJRZx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2013 13:25:53 -0400
In-Reply-To: <1378821408.13541.26.camel@linux-fkkt.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: hare@suse.de, linux-scsi@vger.kernel.org

On Tue, 10 Sep 2013, Oliver Neukum wrote:

> Hi Hannes,
> 
> you objected to this patch saying there's a possibilty that
> HS devices may also need this feature, which would require
> a quirk. Does this mean that the patch is acceptable only
> with an additional predefined quirk, or do you insist that all
> devices be handled with quirks?

Indeed, we already know of one or two high-speed devices that suffer
from this bug:

	http://marc.info/?l=linux-usb&m=133586313307042&w=2

This may influence your decision.  I'm not certain whether it is 
important enough to merit a new quirk flag, but people experiencing the 
problem may have some strong opinions.

Alan Stern

