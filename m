From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: new driver
Date: Sun, 15 Feb 2004 15:35:45 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <402FD821.4060800@pobox.com>
References: <200402141906.12087.kschneider@bout-tyme.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:32223 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S265193AbUBOUf6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 15 Feb 2004 15:35:58 -0500
In-Reply-To: <200402141906.12087.kschneider@bout-tyme.net>
List-Id: linux-scsi@vger.kernel.org
To: Ken Schneider <kschneider@bout-tyme.net>
Cc: linux-scsi@vger.kernel.org

Ken Schneider wrote:
> I have been sent the sources for the LSI LOGIC, Inc. Ultra ATA100 IDE raid 
> controller as found on the mainboard of the HP ML330 computer. I requested 
> information concerning the inclusion of the code into the kernel tree and 
> have been informed that the source is open and can be included as stated in 
> all of the .c and .h files.


Just to echo the others...

You need to add two drivers:

1) low-level hardware driver for this LSI hardware
2) software RAID driver

They are distinct and separate, when you're talking about software RAID.

Regards,

	Jeff (SATA maintainer)



