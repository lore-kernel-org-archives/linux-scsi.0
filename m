From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] aacraid: New products patch
Date: Mon, 20 Jun 2005 14:48:50 -0400
Message-ID: <42B70F92.7020709@pobox.com>
References: <60807403EABEB443939A5A7AA8A7458B01520E90@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:49569 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261440AbVFTSs4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Jun 2005 14:48:56 -0400
In-Reply-To: <60807403EABEB443939A5A7AA8A7458B01520E90@otce2k01.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Cc: Mark Haverkamp <markh@osdl.org>, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi <linux-scsi@vger.kernel.org>

Salyzyn, Mark wrote:
> diff -u a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -671,7 +671,7 @@
>  
>  	bus_info = (struct aac_bus_info_response *) fib_data(fibptr);
>  
> -	memset(info,0,sizeof(*bus_info));
> +	memset(bus_info,0,sizeof(*bus_info));


If you're going to patch this area, please add whitespace.

	Jeff


