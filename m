Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 265D9C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 03:03:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231408AbhLMDDl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Dec 2021 22:03:41 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:35403 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbhLMDDl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Dec 2021 22:03:41 -0500
Received: by mail-pf1-f169.google.com with SMTP id p13so13738140pfw.2
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 19:03:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nBD9vPCgXQUjez5dQodu85EHR5gcaW86TnVBtlDi2U0=;
        b=fmtzzZV5/FB25OxORDseujalgDj47Q2x1yRogUUCLUlxDfeIoUOw23CHOzkdWobeb0
         OkGxmQVEqTQmTaL3tZubnNm/vD8+QvQTL8ytOrZkLB7EJCo3maK6PHGOY5QC4oaMfQWK
         BbrKTvBdxFIZf8NciJtSZP5aXFHWtFqJZxcZKBe4b/QHwIs1b4U+REqrl2lhdsoZ1M8o
         ybzzmlBPujtqGA/BJunVgbw767CZCBeH8OHrK8PA5gL1on6YvgvQ/u/nYOuZVFoGgc7i
         oOLeFDuOy/HFSWnoe01ee4BfT1gK9CuWJ6JyEHMOyytaFWbZI/QAh5Y/81ygsaKzDbQn
         H4Dg==
X-Gm-Message-State: AOAM533UfrJUC7zm1Q1S+bv5VY+0+Iznso2Ej3+gxn9Wg8XOpx/h9ejf
        dItL93aFZ77XTO0fjjFgsFQ=
X-Google-Smtp-Source: ABdhPJx8Nm/EZBIOY6rD2nBi2iOrUxUX3m7HjOA8lALCuWAr6WCyrqTW+RH42pvC6xkBo2W8rJnqvA==
X-Received: by 2002:aa7:970e:0:b0:4a2:655f:7a12 with SMTP id a14-20020aa7970e000000b004a2655f7a12mr31095869pfg.65.1639364620574;
        Sun, 12 Dec 2021 19:03:40 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id s21sm10367751pfk.3.2021.12.12.19.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Dec 2021 19:03:40 -0800 (PST)
Message-ID: <1ad52cc7-f736-6e75-36e0-414ac32f70b4@acm.org>
Date:   Sun, 12 Dec 2021 19:03:38 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 01/12] scsi: core: Suppress a kernel-doc warning
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211129194609.3466071-1-bvanassche@acm.org>
 <20211129194609.3466071-2-bvanassche@acm.org>
 <393c6d58-8af5-5849-7962-64153e3ec290@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <393c6d58-8af5-5849-7962-64153e3ec290@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/21 18:53, Randy Dunlap wrote:
> On 11/29/21 11:45, Bart Van Assche wrote:
>> -/**
>> +/*
>>    * scsi_enable_async_suspend - Enable async suspend and resume
>>    */
>>   void scsi_enable_async_suspend(struct device *dev)
>>
> 
> Why this instead of describing @dev: ?
> 
>   * @dev: the struct device to enable for async suspend and resume

Hi Randy,

I expect that anyone can guess the meaning of the @dev argument without 
adding any explanation. Hence the choice to convert the kernel-doc 
comment into a regular comment.

Thanks,

Bart.
