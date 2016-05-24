From: Hans de Goede <hdegoede@redhat.com>
Subject: Re: [PATCH v2 1/1] uas: remove can_queue set in host template
Date: Tue, 24 May 2016 08:58:30 +0200
Message-ID: <4b23f12a-eb80-8196-a266-c209cdb5f387@redhat.com>
References: <574359f3.4667620a.6c0f.528f@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751634AbcEXG6h (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2016 02:58:37 -0400
In-Reply-To: <574359f3.4667620a.6c0f.528f@mx.google.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tom.ty89@gmail.com, gregkh@linuxfoundation.org
Cc: kraxel@redhat.com, stern@rowland.harvard.edu, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hi,

On 23-05-16 21:28, tom.ty89@gmail.com wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> Commit 198de51dbc34 ("USB: uas: Limit qdepth at the scsi-host level") made
> qdepth limit set in host template (`.can_queue = MAX_CMNDS`) redundant.
> Removing it to avoid confusion.
>
> Signed-off-by: Tom Yan <tom.ty89@gmail.com>

I agree removing this is good:

Acked-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans


>
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 4d49fce..e03c490 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -848,7 +848,6 @@ static struct scsi_host_template uas_host_template = {
>  	.slave_configure = uas_slave_configure,
>  	.eh_abort_handler = uas_eh_abort_handler,
>  	.eh_bus_reset_handler = uas_eh_bus_reset_handler,
> -	.can_queue = MAX_CMNDS,
>  	.this_id = -1,
>  	.sg_tablesize = SG_NONE,
>  	.skip_settle_delay = 1,
>
