Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14E1C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 02:53:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231381AbhLMCxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Dec 2021 21:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231293AbhLMCxn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Dec 2021 21:53:43 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70831C06173F
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 18:53:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=aVdBexTQS9lwFfP2WiGUzdNjp2saHwdM0sW27JJXxRw=; b=nSkgDxfPFc+CkF5hme4XnTGB+0
        pWOeKHm0qfIM2fxQ2be2xn4cGjsZmu40hYvzCLhy6B1/vzVKsiuxQWwZU4Zp9uw6kTPz0WMPiALfu
        2gDujc6dvtk6IgGsTdIMlNgwYItO7xO35kE9PxVA88cZ8zwBnf8BuoRTno94XHALeshJBsUkCAQa/
        7HYWVM0jVvx9SyqvtBIUkbf6nJRYjz7s+9hH6idzW1ScMBZGhkVf0XFV+29MBkJbtjImkVoVbgQRM
        fJtem8/6PIsx56T5DAq1SD9gri2Xc6BzJ6B0VIJnpwEbYyp/xp7YzLmROCGzQij4X+1AdPCefrN9U
        QwA78pug==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mwbSl-00133Q-RR; Mon, 13 Dec 2021 02:53:16 +0000
Message-ID: <393c6d58-8af5-5849-7962-64153e3ec290@infradead.org>
Date:   Sun, 12 Dec 2021 18:53:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 01/12] scsi: core: Suppress a kernel-doc warning
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211129194609.3466071-1-bvanassche@acm.org>
 <20211129194609.3466071-2-bvanassche@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20211129194609.3466071-2-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart, Martin,

On 11/29/21 11:45, Bart Van Assche wrote:
> Suppress the following kernel-doc warning:
> 
> drivers/scsi/scsi_scan.c:129: warning: Function parameter or member 'dev' not described in 'scsi_enable_async_suspend'
> 
> Fixes: a19a93e4c6a9 ("scsi: core: pm: Rely on the device driver core for async power management")
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_scan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 23e1c0acdeae..2f80509fa036 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -122,7 +122,7 @@ struct async_scan_data {
>  	struct completion prev_finished;
>  };
>  
> -/**
> +/*
>   * scsi_enable_async_suspend - Enable async suspend and resume
>   */
>  void scsi_enable_async_suspend(struct device *dev)
> 

Why this instead of describing @dev: ?

 * @dev: the struct device to enable for async suspend and resume


thanks.
-- 
~Randy
