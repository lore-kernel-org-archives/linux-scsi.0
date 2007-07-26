From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH] Remove libsas PCI dependencies
Date: Thu, 26 Jul 2007 09:30:09 -0400
Message-ID: <46A8A1E1.3040707@garzik.org>
References: <Pine.SOC.4.64.0707261129220.17385@math.ut.ee>	 <46A867AB.7050007@garzik.org> <1185454007.3501.34.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:47557 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754290AbXGZNaL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 09:30:11 -0400
In-Reply-To: <1185454007.3501.34.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Meelis Roos <mroos@linux.ee>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>, "Darrick J. Wong" <djwong@us.ibm.com>, Andrew Morton <akpm@linux-foundation.org>

James Bottomley wrote:
> Realistically, even for parisc, I can't see anyone producing a non-PCI
> SAS device (even though I'd like one).

A non-PCI device embedded on an SoC or system bus is highly -likely-, IMO.

SAS+SATA silicon (w/out firmware assist as with aic94xx) is the 
direction that Marvell and Broadcom have gone.  I would say it's 
practically inevitable that someone will embed a SAS+SATA chip eventually.


> This should become enum dma_data_direction if we're going to go the
> generic route.

Updated.

	Jeff


