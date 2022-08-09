Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF014C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:23:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343864AbiHITXE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343857AbiHITXD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:23:03 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1243A8;
        Tue,  9 Aug 2022 12:23:02 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id h21-20020a17090aa89500b001f31a61b91dso18583770pjq.4;
        Tue, 09 Aug 2022 12:23:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=GB5/gpb1OgcApv3VLaq+R+qJBjIrW8t5fst4dgp4M/I=;
        b=yLsDaOgM+/O/FdYrdQrvWNdxUPmiHnFt9fSFHRQd6pMM7WDxg9AAA2i/1x5ZcDUqGJ
         h/Uf/yZPXeqYqmyZ0n0/v00aCrXg1S82iArZt420tXutC6WHECZt12XQqHe8R4gnNaDg
         kvwE7JzXv8imhz6pBdKjid11kS44cgJOJ8rIgT6GNwvQd9b8fGnlfBVdEnGt+LKpWUOb
         Vook7gZpyAmJW0WRddvbQqqdeNglafMqYVRq7Kmb/IALdv42pK+rkuxLbYFnALf6j0xJ
         o6D88tFbZSa54jffb+ve9/TLD67s75ZyTd4iWLU5sIZ2SquytOCP1fEP/vFXE8Pqm7pI
         2g8w==
X-Gm-Message-State: ACgBeo0RHF1E8xX1E+WtLOeDHQEFQuclfzNAL6NvDiWtsBuTNlkAsxUc
        XyJSFFrP9582nf9OxLjbCGc=
X-Google-Smtp-Source: AA6agR6wXr3LrU89unpnzRfKNnDFJjzXPc1yphMgotIaMLByFlUYhvhPY4knSiM+7DE0jLsYRY8xmQ==
X-Received: by 2002:a17:903:447:b0:16e:cbe3:29de with SMTP id iw7-20020a170903044700b0016ecbe329demr24670117plb.65.1660072982212;
        Tue, 09 Aug 2022 12:23:02 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id i17-20020a170902c95100b0016fa99912d7sm9213472pla.141.2022.08.09.12.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:23:01 -0700 (PDT)
Message-ID: <5cf33826-7dc7-7af4-c3f3-b4631b78c93b@acm.org>
Date:   Tue, 9 Aug 2022 12:22:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 02/20] scsi: Rename sd_pr_command.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk, hch@lst.de,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-3-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220809000419.10674-3-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/22 17:04, Mike Christie wrote:
> Rename sd_pr_command to sd_pr_out_command to match a
> sd_pr_in_command helper added in the next patches.

No trailing dots at the end of the patch subject please (this patch and 
other patches). Otherwise this patch looks good to me.

Thanks,

Bart.
