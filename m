From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: Thu, 07 Oct 2004 17:44:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <4165B8CC.7010700@pobox.com>
References: <4161A06D.8010601@rtr.ca> <4165B233.9080405@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:25275 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S267555AbUJGVo7
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Oct 2004 17:44:59 -0400
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

libata exists as it does simply due to how it evolved.

Please just submit patches containing the changes you want, I'm very 
receptive to improvements that increase the breadth of libata's coverage.

As the name implies, libata is just a library of code and nothing more. 
  A driver could choose to use the to/from FIS functions and none of the 
driver architecture, for example.  libata exists solely to concentrate 
ATA code into a single location.

(similarly, include/linux/ata.h exists to concentrate all ATA-related 
defines in one location)

	Jeff



