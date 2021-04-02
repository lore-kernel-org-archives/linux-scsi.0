Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E86C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 16:03:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDE08610F7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 16:03:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235797AbhDBQDW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 12:03:22 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:46938 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235650AbhDBQDV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 12:03:21 -0400
Received: by mail-pj1-f54.google.com with SMTP id q6-20020a17090a4306b02900c42a012202so2749118pjg.5;
        Fri, 02 Apr 2021 09:03:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/bM+oiScGUvkB7MEw5O1uNr1opMHm9OV5eONmSfw2pg=;
        b=VJuCqfdiUmlZB4Kuk1oDy3DCtG6QJ+Y6JK+x9mE97jFJhxdgKsmrUwIbS9D3Cy/NGK
         037MnMNPNaFcvMfL+5X3ImYHnd25HoO2izMGuyBH+ZSkxhURDroUVPX19Az6/llAp5VS
         HHi+XgBc+bDOqFx7G66CwOKziJ5/p0yhsZch9lwbKItPjEs2dAkarfldu9A+SnV9LlYA
         /GSrRCC9ZW4kfJ0GnJU1CLphkyfuk1XOkF35Yb+z/+q1Gu1Pg10xsvGycyUcxeziHYio
         HJk6yfsvQnNrCBpjlaNjssF7aevQ6sshiCuPJVpiUOQNYH5hUewaOrcReLi5eAVCC3ZR
         Rzww==
X-Gm-Message-State: AOAM533Wh2ylc4iM04aTrfVdUlDmS7PYBCIUDBwWdAqH7naNcR2V+GsQ
        M7+KGwY0ZP6v83L9yrHW2Gvzmm2ZNCIQ+Q==
X-Google-Smtp-Source: ABdhPJyq4imJMPjFhrdL6fSbnk0sT1cuKMxi1zBfb6ce9a8vvr0/zeFCnKPCyPX+2UYEJOO+J6zWJg==
X-Received: by 2002:a17:90a:5884:: with SMTP id j4mr15096562pji.33.1617379400125;
        Fri, 02 Apr 2021 09:03:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b5d6:3f29:a586:36e2? ([2601:647:4000:d7:b5d6:3f29:a586:36e2])
        by smtp.gmail.com with ESMTPSA id c11sm8381529pgk.83.2021.04.02.09.03.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 09:03:19 -0700 (PDT)
Subject: Re: [PATCH v1 2/2] scsi: pm8001: clean up for open brace
To:     Luo Jiaxing <luojiaxing@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
 <1617354522-17113-3-git-send-email-luojiaxing@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <614f4c0f-deaa-ad3a-09d1-ac6e8ec2d143@acm.org>
Date:   Fri, 2 Apr 2021 09:03:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617354522-17113-3-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/2/21 2:08 AM, Luo Jiaxing wrote:
> -static struct flash_command flash_command_table[] =
> -{
> +static struct flash_command flash_command_table[] = {
>       {"set_nvmd",    FLASH_CMD_SET_NVMD},
>       {"update",      FLASH_CMD_UPDATE},
>       {"",            FLASH_CMD_NONE} /* Last entry should be NULL. */

Can 'flash_command_table' be declared const?

> -static struct error_fw flash_error_table[] =
> -{
> +static struct error_fw flash_error_table[] = {
>       {"Failed to open fw image file",	FAIL_OPEN_BIOS_FILE},
>       {"image header mismatch",		FLASH_UPDATE_HDR_ERR},
>       {"image offset mismatch",		FLASH_UPDATE_OFFSET_ERR},

Can 'flash_error_table' be declared const?

Thanks,

Bart.
