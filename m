From: Alex Williamson <alex.williamson@hp.com>
Subject: Re: Symbios 53C8XX broken on ia64?
Date: Tue, 23 Mar 2004 09:47:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1080060468.2091.28.camel@patsy.fc.hp.com>
References: <je3c80ph2o.fsf@sykes.suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from atlrel6.hp.com ([156.153.255.205]:36301 "EHLO atlrel6.hp.com")
	by vger.kernel.org with ESMTP id S262675AbUCWQsC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Mar 2004 11:48:02 -0500
In-Reply-To: <je3c80ph2o.fsf@sykes.suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Andreas Schwab <schwab@suse.de>
Cc: linux-ia64 <linux-ia64@vger.kernel.org>, linux-scsi@vger.kernel.org


   Seems to work just fine on an rx2600 w/ latest bk plus this patch
that was being tossed around yesterday:

http://marc.theaimsgroup.com/?l=linux-ia64&m=107999504909154&w=2

I'm building it statically in my case.

	Alex

On Mon, 2004-03-22 at 17:01, Andreas Schwab wrote:
> Has anyone been able to get the sym53c8xx_2 driver in 2.6.5-rc2 working on
> HP zx1?  On the machines I tried it does not find any disks anymore.  This
> has been working fine with 2.6.3.
> 
> CONFIG_SCSI_SYM53C8XX_2=m
> CONFIG_SCSI_SYM53C8XX_DMA_ADDRESSING_MODE=1
> CONFIG_SCSI_SYM53C8XX_DEFAULT_TAGS=16
> CONFIG_SCSI_SYM53C8XX_MAX_TAGS=64
> # CONFIG_SCSI_SYM53C8XX_IOMAPPED is not set
> 
> Andreas.
-- 
Alex Williamson                             HP Linux & Open Source Lab

