From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH v3] block: move RAID transport class to BLOCK menu
Date: Sun, 04 Nov 2007 15:19:47 -0500
Message-ID: <472E2963.20202@garzik.org>
References: <20071104104423.d595c0e7.randy.dunlap@oracle.com>	<20071104185806.GV15111@parisc-linux.org>	<472E16BA.4090708@garzik.org>	<472E1FD7.1010508@oracle.com>	<472E2458.7060905@garzik.org>	<472E2567.4010304@oracle.com>	<472E264D.4010006@garzik.org> <20071104121727.c2621fda.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41179 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751147AbXKDUUE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 4 Nov 2007 15:20:04 -0500
In-Reply-To: <20071104121727.c2621fda.randy.dunlap@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Matthew Wilcox <matthew@wil.cx>, scsi <linux-scsi@vger.kernel.org>, jejb <james.bottomley@steeleye.com>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>

Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Move RAID class configuration to the BLOCK menu since it is not
> SCSI-specific.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  block/Kconfig             |    5 
>  block/Makefile            |    2 
>  block/raid_class.c        |  313 +++++++++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/Kconfig      |    7 -
>  drivers/scsi/Makefile     |    2 
>  drivers/scsi/raid_class.c |  314 ----------------------------------------------
>  6 files changed, 320 insertions(+), 323 deletions(-)

ACK


