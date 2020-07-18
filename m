Return-Path: <SRS0=8IEi=A5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E6DEC433E2
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:26:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6293320657
	for <linux-scsi@archiver.kernel.org>; Sat, 18 Jul 2020 20:26:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727096AbgGRUZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jul 2020 16:25:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44257 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726916AbgGRUZ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2020 16:25:58 -0400
Received: by mail-pg1-f193.google.com with SMTP id j19so8332316pgm.11;
        Sat, 18 Jul 2020 13:25:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=mgFAz3AhMPggh8gTyoyGEbJWp9KY0vdf8a981yFIJ6k=;
        b=UI5BaOvF5S3bsKNDOjtoukPK4hfRlDvTsW0eVMk631YST6BnlRgbP/q7jEdrUdfM0J
         9OpFnrr9AMnoatugPSEoBiSQfRrIgQgdfyRSfkmiS20dTz47jpczD49FQYgp+lKUUxaO
         A0vN/YMIOWojXIU69sXzeXlm67JezPz9keapOScogW7znUzTQo9xJSHusq98XxNDJ63t
         1aCneEfRYcG8933uA4u61i975F9xS1LPEAHPQSItLpbV43c17erAqIhlDjBZrizOC/ZK
         Z60vxGIR+Kw4bzegUoMoQXgUAecmn7X3es7P2g2Btoo8kJRXrdXxPFvpSUuYhlIffQzO
         MJAQ==
X-Gm-Message-State: AOAM530qzXeP9MXIvXopQGbH7LGBU5PLM6pY3/vqx9EFTLYD5IbifMNu
        DRvqWM7T2qyH4HOfKDUl/oA=
X-Google-Smtp-Source: ABdhPJwqRgznEsDKeY9UbN4csmXPzHZIHNsg5ey3lrCcMSMPMzwPmnCZOZrENoow1aTUzVPRwPCnnw==
X-Received: by 2002:a63:7054:: with SMTP id a20mr13087288pgn.17.1595103957944;
        Sat, 18 Jul 2020 13:25:57 -0700 (PDT)
Received: from [192.168.50.147] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id lw5sm6516373pjb.37.2020.07.18.13.25.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jul 2020 13:25:57 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: add missing newline when
 printing 'enable' by sysfs
To:     Xiongfeng Wang <wangxiongfeng2@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, john.garry@huawei.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        guohanjun@huawei.com
References: <1594975472-12486-1-git-send-email-wangxiongfeng2@huawei.com>
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
Message-ID: <88b08a41-55b2-ae5d-fbe5-24439429855f@acm.org>
Date:   Sat, 18 Jul 2020 13:25:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594975472-12486-1-git-send-email-wangxiongfeng2@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-07-17 01:44, Xiongfeng Wang wrote:
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 182fd25..e443dee 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -563,7 +563,7 @@ static ssize_t do_sas_phy_enable(struct device *dev,
>  {
>  	struct sas_phy *phy = transport_class_to_phy(dev);
>  
> -	return snprintf(buf, 20, "%d", phy->enabled);
> +	return snprintf(buf, 20, "%d\n", phy->enabled);
>  }

For future sysfs show function patches, please use PAGE_SIZE as second
snprintf() argument or use sprintf() instead of snprintf() because in
this case it is clear that no output buffer overflow will happen. Using
any other size argument than PAGE_SIZE makes patches like the above
harder to verify than necessary. Anyway:

Reviewed-by: Bart van Assche <bvanassche@acm.org>
