From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] ipr: Fix HDIO_GET_IDENTITY oops for SATA devices
Date: Mon, 02 Jun 2008 12:08:14 -0400
Message-ID: <48441AEE.6050605@garzik.org>
References: <12124164141515-patch-mail.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:43905 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752595AbYFBQIU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 2 Jun 2008 12:08:20 -0400
In-Reply-To: <12124164141515-patch-mail.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, thlin@linux.vnet.ibm.com, linux-ide@vger.kernel.org, miltonm@bga.com

Brian King wrote:
> Currently, ipr does not support HDIO_GET_IDENTITY to SATA devices.
> An oops occurs if userspace attempts to send the command. Since hald
> issues the command, ensure we fail the ioctl in ipr. This is a
> temporary solution to the oops. Once the ipr libata EH conversion
> is upstream, ipr will fully support HDIO_GET_IDENTITY.
> 
> Tested-by: Milton Miller <miltonm@bga.com>
> Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6-bjking1/drivers/scsi/ipr.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

I was pretty happy with the rough draft of your EH conversion...  where 
does that stand now?

	Jeff



