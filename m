Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 393BCC10F25
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:40:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A0972075A
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 02:40:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726339AbgCHCkx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 7 Mar 2020 21:40:53 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:43434 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726284AbgCHCkx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 7 Mar 2020 21:40:53 -0500
Received: by mail-pf1-f194.google.com with SMTP id c144so3165107pfb.10
        for <linux-scsi@vger.kernel.org>; Sat, 07 Mar 2020 18:40:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=wLqJdZTncUBKwxSeBPicWA0zkriCSOscov5Ay2qbZLE=;
        b=n5RMY8kRiYi2bpn+hrNb8G+0AaAFKYrbULqYNwKX0DVqZ17GgtMTfsbgup5cqAAhkW
         g5y7XVAPKXMGB2SRWByLAS3Z1Vr9ko1qE9UabMNE15flmZnKIIcg7gryMOhmgEgvW7zx
         4u1N8cJ3qcxPMVAK/T+W9Kn1B0FUHFQuk7W7NqzmpPSLc2nEoWv5y3nS34n13yBHlZAK
         dfZagcsuMo5AIpfwXGd5lZ5sRg7IdDnfsMcZU5F17Qos4VnTQLQPnjIvf5nhqFdzXEe3
         J/gi5SA2Seq2wCsEf0zHSoz4u6VJygeAyuLmZidwZS5dSdXqBLC02cFCvKt7K5amAk8o
         UFXQ==
X-Gm-Message-State: ANhLgQ14eMLvbp6opDXhG3zLKs2SrBx+QO3Q1dnd3zwyZyFcmSFP3rVk
        AJtTePj50FSE+SQnMaTgNXY=
X-Google-Smtp-Source: ADFU+vt3FHqeQgC0et0yHkgQ+EuhH7MhotrS7sRzFRHYM0kqrx0VQr04kKQqes8+YNUA9Js/pz0JIA==
X-Received: by 2002:a63:c54b:: with SMTP id g11mr10271139pgd.164.1583635250804;
        Sat, 07 Mar 2020 18:40:50 -0800 (PST)
Received: from ?IPv6:2601:647:4000:d7:b9ba:8890:46d5:d60d? ([2601:647:4000:d7:b9ba:8890:46d5:d60d])
        by smtp.gmail.com with ESMTPSA id b16sm12209195pff.25.2020.03.07.18.40.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Mar 2020 18:40:50 -0800 (PST)
Subject: Re: [PATCH] fusion: fix if-statement empty body warning
To:     Randy Dunlap <rdunlap@infradead.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <ce2233a7-e470-0fc2-f908-75f52c6ec3e1@infradead.org>
 <d9dbd9ac-4f48-eb3d-b2ff-2cceb255f9e9@infradead.org>
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
Message-ID: <cbf84b8c-1130-53cf-5416-f4099bbd4ce0@acm.org>
Date:   Sat, 7 Mar 2020 18:40:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <d9dbd9ac-4f48-eb3d-b2ff-2cceb255f9e9@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-03-07 18:10, Randy Dunlap wrote:
> Would you (anyone) rather see something different here,
> such as using pr_debug() or no_printk() instead of an
> empty do-while loop?
> 
> I went with a minimal change, but I can do something else
> if that is preferred.

If "do {} while(0)" is changed into "no_printk x", feel free to add the
following:

Reviewed-by: Bart van Assche <bvanassche@acm.org>
