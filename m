From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Wed, 13 Oct 2004 16:04:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <416D8A4E.5030106@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:7076 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269803AbUJMUEn
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 Oct 2004 16:04:43 -0400
In-Reply-To: <4165B233.9080405@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Mark Lord wrote:
> On a related note..
> 
> In the longer term, I'd like Jeff & I to get together and agree
> upon some interface changes in libata to make it easier for this
> driver (and others) to share more of the code dealing with
> the emulation of non-data SCSI commands like INQUIRY and friends.
> 
> Right now that's not as easy as it could be, due to the specialized
> libata struct parameters required, but I think it could be harmonized.

I recall this but don't see it in my inbox anymore... did I adequately 
respond?

The easy answer is always:  send patches.  that's the best way to 
illustrate your design, and the quickest way to get the changes you want 
into the kernel.

	Jeff



