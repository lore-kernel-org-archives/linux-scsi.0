Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6BD7ECAAD8
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Sep 2022 14:01:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbiIUOBS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Sep 2022 10:01:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229675AbiIUOBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Sep 2022 10:01:05 -0400
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DBD857C4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2022 07:01:04 -0700 (PDT)
Received: by mail-pj1-f42.google.com with SMTP id s14-20020a17090a6e4e00b0020057c70943so14364814pjm.1
        for <linux-scsi@vger.kernel.org>; Wed, 21 Sep 2022 07:01:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=dc2N48lbLb5DCtIxznltNNEh4FmiPkIw8yoVU/Kd3lA=;
        b=ZzLa7Ry67NwDdvkDlQYK9ZU+NfinV9fe3zgRm+OolOGVYOVd/iDHadSCr6RWEFzBUe
         iYjxX+OwFUZ8+VbNSiDxsVnibqmHiRcbXoEDF8FUrKna0/uYcsi5PrI1b24zUQ+OyjKC
         AyUE3Ae3WMC6Fte7RSWNx+B9Yg7u2Q3J/a0y5unGE7M9jQZrC7XtQslvDL3ztBPnsCRH
         EkQtPAmCz+mXSuVRfbhCBALZfbpwWr1gl/ogJX41VKs9PzK5igHcLnJxDd+ZqeEnKlXl
         eBCCC1SKlx/ycLmWv9kMLkrvngnfkxQSvdOM6KWfW9yZNTb/KOFTLX/X9VzlnHSYjYGO
         3CBA==
X-Gm-Message-State: ACrzQf2pfZjDPyMZKA+F/MLgqKHQkHKDfcmNmDaejwLhL+9Fvzv+/DB8
        /bp/nBJO3hYNw11fiYZMN9Y=
X-Google-Smtp-Source: AMsMyM5eL+ftYMR4EIG92nU0SWKBtJxK+SqeYBziDCkwBJvxbm0eqBqzDnk46mf5G6WqKiFcqoWzKw==
X-Received: by 2002:a17:902:d2cc:b0:178:1742:c182 with SMTP id n12-20020a170902d2cc00b001781742c182mr4924691plc.98.1663768863929;
        Wed, 21 Sep 2022 07:01:03 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 17-20020a170902e9d100b001755e4278a6sm2002821plk.261.2022.09.21.07.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 07:01:03 -0700 (PDT)
Message-ID: <3cd985aa-d394-c832-dc88-121c55c54e69@acm.org>
Date:   Wed, 21 Sep 2022 07:01:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH V2] scsi: core: Add io timeout count for scsi device
Content-Language: en-US
To:     Wu Bo <wubo40@huawei.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, qiuchangqi.qiu@huawei.com
References: <1663666339-17560-1-git-send-email-wubo40@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1663666339-17560-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/22 02:32, Wu Bo wrote:
> Current the scsi device has iorequest count, iodone count
> and ioerr count, but lack of io timeout count.
> 
> For better tracking of scsi io, So add it now.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
