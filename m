From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 4/4] scsi: megaraid_sas - Update the Version and
	Changelog
Date: Mon, 17 Mar 2008 15:54:45 -0500
Message-ID: <1205787285.6767.185.camel@localhost.localdomain>
References: <9738BCBE884FDB42801FAD8A7769C26501CE50E4@NAMAIL1.ad.lsil.com>
	 <1195251505.3407.30.camel@localhost.localdomain>
	 <9738BCBE884FDB42801FAD8A7769C26501C9A4AF@NAMAIL1.ad.lsil.com>
	 <1205824386.7238.7.camel@pcp021067pcs.se.lsil.com>
	 <1205741897.7479.22.camel@pcp021067pcs.se.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40660 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751717AbYCQUyt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Mar 2008 16:54:49 -0400
In-Reply-To: <1205741897.7479.22.camel@pcp021067pcs.se.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: bo yang <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, neela.kolli@lsi.com

On Mon, 2008-03-17 at 04:18 -0400, bo yang wrote:
> Update the Version and ChangeLog
> 
> Signed-off-by Bo Yang<bo.yang@lsi.com>
> 
> ---
>  Documentation/scsi/ChangeLog.megaraid_sas |   22 ++++++++++++++++++++
>  drivers/scsi/megaraid/megaraid_sas.c      |    2 -
>  drivers/scsi/megaraid/megaraid_sas.h      |    6 ++---
>  3 files changed, 26 insertions(+), 4 deletions(-)
> 
> diff -rupN linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas
> --- linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas	2008-03-10 10:17:25.000000000 -0400
> +++ linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas	2008-03-10 10:41:39.000000000 -0400
> @@ -3,6 +3,28 @@
>  			Sumant Patro
>  			Bo Yang
>  
> +2 Current Version : 00.00.03.20
> +3 Older Version   : 00.00.03.16
> +
> +1. Sense buffer ptr data type in the ioctl path is reverted  back to
> +	u32 * as in previous versions of driver.
> +
> +2. Fixed the driver frame count.
> +	When Driver sent wrong frame count to firmware.  As this particular
> +	command is sent to drive, FW is seeing continuous chip resets and so
> +	the command will timeout.
> +
> +3. Add the new controller(1078DE) support to the driver.

It would be nice if the git change log were this detailed, as well
please.

> +4. Increase the max_wait to 60 from 10 in the controller operational status.
> +	With this max_wait increase, driver will make sure the FW will finish
> +	the pending cmd for KDUMP case.   

Where did this change come from?  It's not in any of this change set
that I can see.

James


