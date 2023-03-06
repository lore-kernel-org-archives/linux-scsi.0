Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AD3C1C61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 23:42:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjCFXmv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 18:42:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCFXmt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 18:42:49 -0500
Received: from mailout.easymail.ca (mailout.easymail.ca [64.68.200.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFCAD3B859
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 15:42:48 -0800 (PST)
Received: from localhost (localhost [127.0.0.1])
        by mailout.easymail.ca (Postfix) with ESMTP id 0A64768B5E;
        Mon,  6 Mar 2023 23:42:48 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo09-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
        by localhost (emo09-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WMV7SDIX_dAO; Mon,  6 Mar 2023 23:42:47 +0000 (UTC)
Received: from mail.gonehiking.org (unknown [38.15.45.1])
        by mailout.easymail.ca (Postfix) with ESMTPA id B348168B5D;
        Mon,  6 Mar 2023 23:42:47 +0000 (UTC)
Received: from [192.168.1.4] (internal [192.168.1.4])
        by mail.gonehiking.org (Postfix) with ESMTP id C4C143EEEA;
        Mon,  6 Mar 2023 16:42:45 -0700 (MST)
Message-ID: <3f4157f2-c1e6-ab19-28b5-806a315cafcc@gonehiking.org>
Date:   Mon, 6 Mar 2023 16:42:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Reply-To: khalid@gonehiking.org
Subject: Re: [PATCH 12/81] scsi: BusLogic: Declare SCSI host template const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-13-bvanassche@acm.org>
From:   Khalid Aziz <khalid@gonehiking.org>
In-Reply-To: <20230304003103.2572793-13-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 5:29 PM, Bart Van Assche wrote:
> Make it explicit that the SCSI host template is not modified.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/BusLogic.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index f7b7ffda1161..72ceaf650b0d 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -54,7 +54,7 @@
>   #define FAILURE (-1)
>   #endif
>   
> -static struct scsi_host_template blogic_template;
> +static const struct scsi_host_template blogic_template;
>   
>   /*
>     blogic_drvr_options_count is a count of the number of BusLogic Driver
> @@ -3663,7 +3663,7 @@ static int __init blogic_parseopts(char *options)
>     Get it all started
>   */
>   
> -static struct scsi_host_template blogic_template = {
> +static const struct scsi_host_template blogic_template = {
>   	.module = THIS_MODULE,
>   	.proc_name = "BusLogic",
>   	.write_info = blogic_wr

Looks good to me.

Acked-by: Khalid Aziz <khalid@gonehiking.org>
