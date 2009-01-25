From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 2/2] ipr: add message to error table
Date: Sun, 25 Jan 2009 08:18:03 -0600
Message-ID: <1232893083.4586.2.camel@localhost.localdomain>
References: <20090123165823.748742817@linux.vnet.ibm.com>
	 <4979FBB1.8050103@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:54478 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbZAYOSH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2009 09:18:07 -0500
In-Reply-To: <4979FBB1.8050103@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Wayne Boyer <wayneb@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2009-01-23 at 09:17 -0800, Wayne Boyer wrote:
> Adds a message to the error table for an error that wasn't previously handled.
> 
> Signed-off-by: Wayne Boyer <wayneb@linux.vnet.ibm.com>
> ---
> 
>  drivers/scsi/ipr.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> Index: linux-2.6/drivers/scsi/ipr.c
> ===================================================================
> --- linux-2.6.orig/drivers/scsi/ipr.c	2009-01-22 15:50:59.000000000 -0800
> +++ linux-2.6/drivers/scsi/ipr.c	2009-01-23 08:55:23.000000000 -0800
> @@ -354,6 +354,8 @@
>  	"9076: Configuration error, missing remote IOA"},
>  	{0x06679100, 0, IPR_DEFAULT_LOG_LEVEL,
>  	"4050: Enclosure does not support a required multipath function"},
> +	{0x06690000, 0, IPR_DEFAULT_LOG_LEVEL,
> +	"4070: Logically bad written to device"},

Neither from the change log nor from the actual text can I tell what the
problem is ... is there a word missing (like block or sector)?

James


