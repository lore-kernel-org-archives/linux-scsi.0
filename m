Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E50E0C433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 04:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9DA66196E
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Mar 2021 04:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbhCVEEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Mar 2021 00:04:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbhCVEDp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Mar 2021 00:03:45 -0400
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A63B6C061574;
        Sun, 21 Mar 2021 21:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:Subject:Sender:
        Reply-To:Cc:Content-ID:Content-Description;
        bh=Y48Ev1RVzB4BPAhMau9NsJrw5B0K7MjyfXuxk95+2Lk=; b=PtbhcnBGysYA0TyXrjMvET4Owr
        MR6qt5D269NS7iwFlMuqs1J4GXsQ1egUOsbm3vwRRN1XjLVFtddcsilSzvkvaAQPWBlFcIXkL4qrg
        zTlRZ7r9l7FYyjiKiwfakqT1ze8jS6vcXdDNmnGMBXkNAgkoGoZT7bJIUhYPZAMW34fl3omwJdkFu
        3qpx+AwJoyC8zO7aSeJ/HH7tDY4FiDzrnxrxKuY/Dd/DPbC8YL0195+3JvMFQr7qmM0LbzaayFWPI
        CxxjyMqzh6xTbTBtdndjwlV00rNES/MFsQfwTYzhQ77c9zriAvG3h8MlmRnmlXjWvderwPEo82YYg
        4x5r1BNg==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by desiato.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOBn4-00Aq62-JC; Mon, 22 Mar 2021 04:03:43 +0000
Subject: Re: [PATCH] scsi: mpt3sas: Fix a typo
To:     Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20210322032145.2242520-1-unixbhaskar@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5aee2ecd-d13f-7fb7-310b-8dcbc21c329c@infradead.org>
Date:   Sun, 21 Mar 2021 21:03:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322032145.2242520-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/21/21 8:21 PM, Bhaskar Chowdhury wrote:
> 
> s/encloure/enclosure/
> 
> Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index ac066f86bb14..398fd07ee9f5 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -5232,7 +5232,7 @@ _base_static_config_pages(struct MPT3SAS_ADAPTER *ioc)
>   * mpt3sas_free_enclosure_list - release memory
>   * @ioc: per adapter object
>   *
> - * Free memory allocated during encloure add.
> + * Free memory allocated during enclosure add.
>   */
>  void
>  mpt3sas_free_enclosure_list(struct MPT3SAS_ADAPTER *ioc)
> --


-- 
~Randy

