From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] New QStor SATA/RAID Driver for 2.6.9-rc2
Date: Tue, 14 Sep 2004 12:21:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <41471A84.4090200@pobox.com>
References: <414711AC.5030200@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:40930 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S269598AbUINQVh
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 14 Sep 2004 12:21:37 -0400
In-Reply-To: <414711AC.5030200@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lsml@rtr.ca>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

Mark Lord wrote:
> My first attempt at posting this seems to have gone AWOL,
> so here it comes again.  Also being posted to linux-scsi.
> 
> Here is the first public release of the 2.6.xx driver
> source code for the Pacific Digital Corporation QStor SATA/RAID chip.
> 
> This 4-channel chip has hardware-assisted RAID0/RAID1/RAID10,
> host-queuing, per-request TCQ/NCQ support, support for hot insertion
> and removal of drives, etc..  The 64-bit/66Mhz chip shows throughput
> in excess of 200MByte/sec on my ancient P3-1GHz test system,
> and can do much better when installed in a PCI-X slot.

How much of the RAID is actually hardware-assisted?


> The driver (attached) supports most of the chip features,
> including host, native and legacy tagged queuing,
> but does not yet include boot-from-raid support (coming soon).
> 
> Both hdparm and smartmontools are fully supported by this driver.

Linus vetoed future SCSI->ATA translators.  He only allowed libata 
because I promised to remove the translation and make it a native block 
driver in the future, which I have been working towards.

	Jeff


