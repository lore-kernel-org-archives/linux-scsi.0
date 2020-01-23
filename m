Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51DEEC32771
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:43:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FF9D2465A
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:43:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725943AbgAWCnS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 21:43:18 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:36905 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAWCnS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Jan 2020 21:43:18 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so520342pjb.2
        for <linux-scsi@vger.kernel.org>; Wed, 22 Jan 2020 18:43:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vs3mL4tJj1KuBJXm1f8hvD9vElGrMQEkKNUTZQ53nfc=;
        b=ZkPgeRL5r3EjD8655XuBfojRuLJh91etu9l4RtMI+7ybJDWVbVHuu9az5jugDw06hB
         JK1qmczMAeXinjOTVpxwdxj2+Bp+W9sZUdhXXWCfawkwppBK6x1PHHoVJC9urNj5K2i0
         8EhqqUnuO6EiNBuPe+0uPrpadjBWm9X+Yx9eHbctgalsO+H4rCnP30GIZPNxsHNvGIp5
         xyubsoC6SCFu9fNlU/Y0cHfMGwco00FILr+NJmPyWXSJ7tkNYtMIIt3T/JBnCbFEblnP
         LGrEHrFUQYaQDRU4Gqi1rRTBrUcHz1U4bUfNsghDZNC4mwGoA8HFP/RRvW+mt+6pCqr1
         uH5w==
X-Gm-Message-State: APjAAAXSzmiMMS4hxQOLeNfUxsfBt1lNpYb99RK4tFstHTj8MgQOKqR2
        YuAWUz8qp1QYPOmSx4LzOKCwk56u
X-Google-Smtp-Source: APXvYqxys6PB1KSNaImd71A7FOG6CRAEFKL7E8KCbRTbcdM60GM+of/YrgRrD1yNtiiSpwrBVvQDdQ==
X-Received: by 2002:a17:90b:344f:: with SMTP id lj15mr2042418pjb.0.1579747397631;
        Wed, 22 Jan 2020 18:43:17 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:d957:4568:237a:bc62? ([2601:647:4000:d7:d957:4568:237a:bc62])
        by smtp.gmail.com with ESMTPSA id i68sm267458pfe.173.2020.01.22.18.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jan 2020 18:43:16 -0800 (PST)
Subject: Re: [PATCH] scsi: Delete extra blank line
To:     Ye Bin <yebin10@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20200122092740.27169-1-yebin10@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Autocrypt: addr=bvanassche@acm.org; prefer-encrypt=mutual; keydata=
 mQENBFSOu4oBCADcRWxVUvkkvRmmwTwIjIJvZOu6wNm+dz5AF4z0FHW2KNZL3oheO3P8UZWr
 LQOrCfRcK8e/sIs2Y2D3Lg/SL7qqbMehGEYcJptu6mKkywBfoYbtBkVoJ/jQsi2H0vBiiCOy
 fmxMHIPcYxaJdXxrOG2UO4B60Y/BzE6OrPDT44w4cZA9DH5xialliWU447Bts8TJNa3lZKS1
 AvW1ZklbvJfAJJAwzDih35LxU2fcWbmhPa7EO2DCv/LM1B10GBB/oQB5kvlq4aA2PSIWkqz4
 3SI5kCPSsygD6wKnbRsvNn2mIACva6VHdm62A7xel5dJRfpQjXj2snd1F/YNoNc66UUTABEB
 AAG0JEJhcnQgVmFuIEFzc2NoZSA8YnZhbmFzc2NoZUBhY20ub3JnPokBOQQTAQIAIwUCVI67
 igIbAwcLCQgHAwIBBhUIAgkKCwQWAgMBAh4BAheAAAoJEHFcPTXFzhAJ8QkH/1AdXblKL65M
 Y1Zk1bYKnkAb4a98LxCPm/pJBilvci6boefwlBDZ2NZuuYWYgyrehMB5H+q+Kq4P0IBbTqTa
 jTPAANn62A6jwJ0FnCn6YaM9TZQjM1F7LoDX3v+oAkaoXuq0dQ4hnxQNu792bi6QyVdZUvKc
 macVFVgfK9n04mL7RzjO3f+X4midKt/s+G+IPr4DGlrq+WH27eDbpUR3aYRk8EgbgGKvQFdD
 CEBFJi+5ZKOArmJVBSk21RHDpqyz6Vit3rjep7c1SN8s7NhVi9cjkKmMDM7KYhXkWc10lKx2
 RTkFI30rkDm4U+JpdAd2+tP3tjGf9AyGGinpzE2XY1K5AQ0EVI67igEIAKiSyd0nECrgz+H5
 PcFDGYQpGDMTl8MOPCKw/F3diXPuj2eql4xSbAdbUCJzk2ETif5s3twT2ER8cUTEVOaCEUY3
 eOiaFgQ+nGLx4BXqqGewikPJCe+UBjFnH1m2/IFn4T9jPZkV8xlkKmDUqMK5EV9n3eQLkn5g
 lco+FepTtmbkSCCjd91EfThVbNYpVQ5ZjdBCXN66CKyJDMJ85HVr5rmXG/nqriTh6cv1l1Js
 T7AFvvPjUPknS6d+BETMhTkbGzoyS+sywEsQAgA+BMCxBH4LvUmHYhpS+W6CiZ3ZMxjO8Hgc
 ++w1mLeRUvda3i4/U8wDT3SWuHcB3DWlcppECLkAEQEAAYkBHwQYAQIACQUCVI67igIbDAAK
 CRBxXD01xc4QCZ4dB/0QrnEasxjM0PGeXK5hcZMT9Eo998alUfn5XU0RQDYdwp6/kMEXMdmT
 oH0F0xB3SQ8WVSXA9rrc4EBvZruWQ+5/zjVrhhfUAx12CzL4oQ9Ro2k45daYaonKTANYG22y
 //x8dLe2Fv1By4SKGhmzwH87uXxbTJAUxiWIi1np0z3/RDnoVyfmfbbL1DY7zf2hYXLLzsJR
 mSsED/1nlJ9Oq5fALdNEPgDyPUerqHxcmIub+pF0AzJoYHK5punqpqfGmqPbjxrJLPJfHVKy
 goMj5DlBMoYqEgpbwdUYkH6QdizJJCur4icy8GUNbisFYABeoJ91pnD4IGei3MTdvINSZI5e
Message-ID: <ef9c6518-bacd-157b-c8da-d30096f4e068@acm.org>
Date:   Wed, 22 Jan 2020 18:43:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200122092740.27169-1-yebin10@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-22 01:27, Ye Bin wrote:
> Signed-off-by: Ye Bin <yebin10@huawei.com>
> ---
>  drivers/scsi/scsi_lib.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 610ee41fa54c..56bd2c13a1fb 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1547,7 +1547,6 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>  	if (unlikely(host->shost_state == SHOST_DEL)) {
>  		cmd->result = (DID_NO_CONNECT << 16);
>  		goto done;
> -
>  	}
>  
>  	trace_scsi_dispatch_cmd_start(cmd);

Although this patch looks fine to me, I'm not sure how useful it is to
delete such extraneous blank lines...

Bart.


