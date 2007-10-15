From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: What still uses the block layer?
Date: Mon, 15 Oct 2007 14:08:41 +0100
Message-ID: <20071015140841.6501da23@the-village.bc.nu>
References: <200710112011.22000.rob@landley.net>
	<200710141845.44750.rob@landley.net>
	<20071015060015.GB32268@kroah.com>
	<200710150336.15774.rob@landley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outpipe-village-512-1.bc.nu ([81.2.110.250]:47770 "EHLO
	the-village.bc.nu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755225AbXJONFi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Oct 2007 09:05:38 -0400
In-Reply-To: <200710150336.15774.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: Greg KH <greg@kroah.com>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <matthew@wil.cx>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, Suparna Bhattacharya <suparna@in.ibm.com>, Nick Piggin <piggin@cyberone.com.au>

> For the desktop I don't object to the scsi layer.  I object to the naming.  
> Merging a half-dozen different types of devices into a single name space, and 

They *are* SCSI devices. USB storage is a SCSI over USB transport. ATAPI
is a SCSI over ATA transport. SAS is much the same thing, as is FC, and
it continues.

With the exception of ATA disk for historical reasons SCSI essentially
won the battle of command formats.

> problems to the point where common cases (like my laptop) aren't impacted by 
> them during early boot.  I don't think anybody (outside the embedded space) 
> is actually upset that /dev/hda now goes through the scsi layer:  they're 
> upset Ubuntu 7.04 no longer calls it /dev/hda.

For the emedded CF using world we could do with a truely dumb ATA only CF
driver, possibly even with pure polled support that used neither the IDE
or the ATA layer.

Alan
