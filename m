From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 01/10] esp_scsi: spellcheck 'driver'
Date: Fri, 21 Nov 2014 10:35:35 +0100
Message-ID: <546F0767.8040304@redhat.com>
References: <1416562077-105715-1-git-send-email-hare@suse.de> <1416562077-105715-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432AbaKUJfs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 21 Nov 2014 04:35:48 -0500
In-Reply-To: <1416562077-105715-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org



On 21/11/2014 10:27, Hannes Reinecke wrote:
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/esp_scsi.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/esp_scsi.h b/drivers/scsi/esp_scsi.h
> index cd68805..b5862e4 100644
> --- a/drivers/scsi/esp_scsi.h
> +++ b/drivers/scsi/esp_scsi.h
> @@ -1,4 +1,4 @@
> -/* esp_scsi.h: Defines and structures for the ESP drier.
> +/* esp_scsi.h: Defines and structures for the ESP driver.
>   *
>   * Copyright (C) 2007 David S. Miller (davem@davemloft.net)
>   */
> 

A good start. :)

Reviewed-by: Paolo Bonzini <pbonzini@redhat.com>
