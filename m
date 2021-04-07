Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4460BC433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 21:56:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0113B611EE
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 21:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233368AbhDGV4a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 17:56:30 -0400
Received: from mail-pf1-f172.google.com ([209.85.210.172]:47094 "EHLO
        mail-pf1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231545AbhDGV41 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 17:56:27 -0400
Received: by mail-pf1-f172.google.com with SMTP id d124so283177pfa.13;
        Wed, 07 Apr 2021 14:56:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ibmtw0ysWt020Up+NK0WF++Cj5A9I9G2v83UTNMUTYk=;
        b=dQiRa6wF75jdNRTiPUj6gCBJrfHBLsKx4Zy+buapp7YB7aSLs9iltsIf0q/E9be8Yt
         9+LiOD1rayPQd4smEAL9ewDXy347SLZNd9AAoXiVnJW41K+K/PSZD8QPkXZ7WzA3yId7
         nXAVm4ePrroXAr69ybC3E/MTS25nI0sZTaHBl/XARaF534B5Nc6c74BQmY+UbkJvgknY
         E8vXqoYD24W+U/5kWbxTMpW+o6TM5wurKzIlD4cCpHbEJhRLxde+ZPLcbb2tpcntNw9r
         L47/1XjiCrQUaulkuB/+B4gX9Y6NiuhpoRy2rCuBAbvPgzj6p84c8rl2JtIyAktv1JCQ
         sqnA==
X-Gm-Message-State: AOAM533s6K2B5c3BqU0haCnwHqUM/t/bnS+fcRBbmn7zAKQD6tHAdqoR
        jdcXmii611ftx2O2rf/apdA=
X-Google-Smtp-Source: ABdhPJzahWR8lrgSn27RynzC+SSKbrb5IL7acaLMe7ll9inYP7ZgPXlQrPy8V8WtT/JpiiAU1oEntg==
X-Received: by 2002:a05:6a00:c93:b029:20d:1b8e:cfaa with SMTP id a19-20020a056a000c93b029020d1b8ecfaamr4734081pfv.48.1617832577086;
        Wed, 07 Apr 2021 14:56:17 -0700 (PDT)
Received: from [192.168.50.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id j30sm23046881pgm.59.2021.04.07.14.56.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Apr 2021 14:56:16 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] scsi: pm8001: clean up for white space
To:     luojiaxing <luojiaxing@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
 <1617354522-17113-2-git-send-email-luojiaxing@huawei.com>
 <7f8aef00-07bc-6b63-19a1-85a8153387cd@acm.org>
 <3dd042b3-eb86-f0aa-5542-3f763f6830e0@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e3532ffe-f750-5c95-7f8f-aafc86b094ca@acm.org>
Date:   Wed, 7 Apr 2021 14:56:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <3dd042b3-eb86-f0aa-5542-3f763f6830e0@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/5/21 11:39 PM, luojiaxing wrote:
> 
> On 2021/4/3 0:01, Bart Van Assche wrote:
>> On 4/2/21 2:08 AM, Luo Jiaxing wrote:
>>>   #define AAP1_MEMMAP(r, c) \
>>> -    (*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) 
>>> * 32 \
>>> +    (*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) 
>>> * 32 \
>>>       + (c)))
>> Since this macro is being modified, please convert it into an inline
>> function such that the type of the arguments can be verified by the
>> compiler.
> 
> Sure, but still keep the function name as AAP1_MEMMAP?

The coding style requires lower case names for functions so the function 
name probably should be converted to lower case.

Thanks,

Bart.
