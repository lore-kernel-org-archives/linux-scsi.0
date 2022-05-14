Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8246CC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 14 May 2022 02:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiENC4t (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 22:56:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiENCzv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 22:55:51 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99A530E201;
        Fri, 13 May 2022 19:28:52 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id y41so9178354pfw.12;
        Fri, 13 May 2022 19:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uPdRVTSHRhMxdYPQ5TrQKUDIXIT7vnTJVRVMA+boZ0c=;
        b=ZuqwqgB+I/l93uva8tJe5TENPoxlquqr1gbTA8eofNTws7UD6g1rEbbxGe9YymcMGM
         bLZ4cPoewAlRWXjtBRyqp7CJw0so0Qn9RVVMC2HZB1eH+azysWGsEMGnB39iHhqG2i+g
         IP8L+ccuayAsEHdk7npJSpyp/ixl2N17gOqVhrGIkFUJ4yEhWya72+6y4XQBhqyKnMT9
         iVyXej3UCDch/y73eIdNHs7qh5XfgbN4n0aFluupxZTrO6fyT4K8ExPyzrTCgK7KQxMp
         3tpVhG4dE+DFJS8H/aL3hKiCmgMga624kbS9m3ZRURQUFADpeAe2FFpLV1b2OgCQTtTv
         R5ng==
X-Gm-Message-State: AOAM530AWiqZS5VymiDnHKj0PTjkvLnaiRhGg73W3CbwRs/mwgGsqHd/
        nsSi55CiLQFdrfu4mQMDh6Q=
X-Google-Smtp-Source: ABdhPJxIyXMN2GEJG9/GrSAUj5r4y55GN3nFZtsuxoDZBFcHB+fNctvGbQg0Mvvn+/Dv518/5og7Vg==
X-Received: by 2002:a05:6a00:1744:b0:510:56fa:d3d6 with SMTP id j4-20020a056a00174400b0051056fad3d6mr7110606pfc.22.1652495332114;
        Fri, 13 May 2022 19:28:52 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id 26-20020aa7915a000000b00512ee2f2363sm831102pfi.99.2022.05.13.19.28.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 19:28:51 -0700 (PDT)
Message-ID: <f5739f11-f07c-3bfe-451a-6d7a24550e61@acm.org>
Date:   Fri, 13 May 2022 19:28:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [bug report] IOMMU reports data translation fault for fio testing
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     "chenxiang66@hisilicon.com >> Xiang Chen" <chenxiang66@hisilicon.com>,
        "liyihang (E)" <liyihang6@hisilicon.com>
References: <2b7d091b-4caf-948f-b41a-29a7fcb9fc2a@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <2b7d091b-4caf-948f-b41a-29a7fcb9fc2a@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/22 05:01, John Garry wrote:
> It could be an issue with the SCSI hba driver.

That seems likely to me.

Thanks,

Bart.
