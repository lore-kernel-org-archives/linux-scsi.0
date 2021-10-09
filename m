Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 86BC5C433F5
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 05:55:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6756560F6B
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Oct 2021 05:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243850AbhJIF5l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Oct 2021 01:57:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232529AbhJIF5k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 9 Oct 2021 01:57:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08B2160F9C;
        Sat,  9 Oct 2021 05:55:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633758944;
        bh=207xyWLEIddswUEcbxh4YpLepcVucsMrvA+d3lONLho=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=li55zUoj73TUHDr8YA7lOOxPLZSohfeSNe/yeBcIFDXI8GgLIULC7gfCzQdI6Fq55
         AkObM1KcK/RgK+bQr7NOBml50xdKUPa1vTIqXmSPPRQrKDVDZxq7kqftYFxNRXVLA+
         AcLQmItjJg1/tCEwYFG5m2JpUdoXRUh5/uonqsSw=
Date:   Sat, 9 Oct 2021 07:55:42 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        David Kershner <david.kershner@unisys.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Re: [PATCH v3 44/46] scsi: unisys: Remove the shost_attrs member
Message-ID: <YWEu3q+fFe2Ax53o@kroah.com>
References: <20211008202353.1448570-1-bvanassche@acm.org>
 <20211008202353.1448570-45-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211008202353.1448570-45-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 08, 2021 at 01:23:51PM -0700, Bart Van Assche wrote:
> This patch prepares for removal of the shost_attrs member from struct
> scsi_host_template.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/staging/unisys/visorhba/visorhba_main.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/staging/unisys/visorhba/visorhba_main.c b/drivers/staging/unisys/visorhba/visorhba_main.c
> index 41f8a72a2a95..f0c647b97354 100644
> --- a/drivers/staging/unisys/visorhba/visorhba_main.c
> +++ b/drivers/staging/unisys/visorhba/visorhba_main.c
> @@ -584,7 +584,6 @@ static struct scsi_host_template visorhba_driver_template = {
>  	.eh_device_reset_handler = visorhba_device_reset_handler,
>  	.eh_bus_reset_handler = visorhba_bus_reset_handler,
>  	.eh_host_reset_handler = visorhba_host_reset_handler,
> -	.shost_attrs = NULL,
>  #define visorhba_MAX_CMNDS 128
>  	.can_queue = visorhba_MAX_CMNDS,
>  	.sg_tablesize = 64,


Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
