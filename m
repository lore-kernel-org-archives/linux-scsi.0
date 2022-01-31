Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 252FDC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:16:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378998AbiAaRQn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:16:43 -0500
Received: from mail-pf1-f181.google.com ([209.85.210.181]:43966 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350146AbiAaRQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 12:16:43 -0500
Received: by mail-pf1-f181.google.com with SMTP id d187so13411234pfa.10
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 09:16:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=wSbqAXXy28Plv4qIX8eQuVDUZBmfWKFDpwlnXjzfdEk=;
        b=D6r9X2htNE9sirxxxOzWdeVd96O67+MkplSRtyrgvGD3n+RUoiG/3oemg2SxDGHDI0
         VZ6T5oq38IFFGhf6R2wjriSPM4lsvFs3/dqdk/fD0jWHBacTLW3ABJcObtWIKwzYhW6g
         KcoyMEi/TnnU85bdCpPQDH6KtyKlfc6Qa3807Qx56Tnzg+vBx3av0CPCYnC+l4j9Xf9j
         kt6v92gVOd95yLk8uTW3AHL5I6JM1t48XS/y7nWZIPF/Nypth0+YnQFa+KbGZ6/mg1sM
         FxVap0dnmrj5b7whiEWyO8eoSGCX807d4uk8xdBYEudknz4JSGrQgldd9Gv6KHbdbBqj
         bnYA==
X-Gm-Message-State: AOAM530+kGe4R5R8zvPjC8UKjrGo1SItOjC6Ntt6NMn34snMllFt6BgB
        jOPCbgz99YL/UZdqSqeDtJM=
X-Google-Smtp-Source: ABdhPJyejLpk+PZg/FYpt+1T8gUF2r3J1XhQPXHwZ4FQcRK0VvSzpB9CCik6bAj1SXa/8JTraODkNA==
X-Received: by 2002:a63:8941:: with SMTP id v62mr17299504pgd.403.1643649402508;
        Mon, 31 Jan 2022 09:16:42 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id p1sm9615364pfh.98.2022.01.31.09.16.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:16:41 -0800 (PST)
Message-ID: <6cfda7c7-ee21-6560-b8a5-980439fb9b6b@acm.org>
Date:   Mon, 31 Jan 2022 09:16:40 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 12/44] aha152x: Move the SCSI pointer to private command
 data
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "fischer@norbit.de" <fischer@norbit.de>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-13-bvanassche@acm.org>
 <431c691634be06d6c97d15da8e6e53fcf580dfe3.camel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <431c691634be06d6c97d15da8e6e53fcf580dfe3.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 02:32, Johannes Thumshirn wrote:
> On Fri, 2022-01-28 at 14:18 -0800, Bart Van Assche wrote:
>> +               if (scsi_pointer->this_residual>0) {
>> +                       while(fifodata>0 && scsi_pointer-
>>> this_residual>0) {
> 
> While you're touching it anyways, can you please add a space around the
> greater than operators?

Will do.

Thanks,

Bart.
