From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [PATCH 4/4] scsi: megaraid_sas - Update the Version andChangelog
Date: Mon, 17 Mar 2008 15:00:18 -0600
Message-ID: <9738BCBE884FDB42801FAD8A7769C26501FE7B33@NAMAIL1.ad.lsil.com>
References: <1205787285.6767.185.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:53475 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754816AbYCQVBA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Mar 2008 17:01:00 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1205787285.6767.185.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, linux-kernel@vger.kernel.org, "Patro, Sumant" <Sumant.Patro@lsi.com>, "Kolli, Neela" <Neela.Kolli@lsi.com>

James,

Sure I will send more details.

Thanks.

Bo Yang 

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@HansenPartnership.com] 
Sent: Monday, March 17, 2008 4:55 PM
To: Yang, Bo
Cc: linux-scsi@vger.kernel.org; akpm@osdl.org;
linux-kernel@vger.kernel.org; Patro, Sumant; Kolli, Neela
Subject: Re: [PATCH 4/4] scsi: megaraid_sas - Update the Version
andChangelog

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
> diff -rupN linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas
linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas
> --- linux-2.6.24_orig/Documentation/scsi/ChangeLog.megaraid_sas
2008-03-10 10:17:25.000000000 -0400
> +++ linux-2.6.24_new/Documentation/scsi/ChangeLog.megaraid_sas
2008-03-10 10:41:39.000000000 -0400
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
> +	When Driver sent wrong frame count to firmware.  As this
particular
> +	command is sent to drive, FW is seeing continuous chip resets
and so
> +	the command will timeout.
> +
> +3. Add the new controller(1078DE) support to the driver.

It would be nice if the git change log were this detailed, as well
please.

> +4. Increase the max_wait to 60 from 10 in the controller operational
status.
> +	With this max_wait increase, driver will make sure the FW will
finish
> +	the pending cmd for KDUMP case.   

Where did this change come from?  It's not in any of this change set
that I can see.

James


