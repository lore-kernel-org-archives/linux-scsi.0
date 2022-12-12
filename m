Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0372C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233150AbiLLVba (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLVb3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:31:29 -0500
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3392A10A7
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:31:28 -0800 (PST)
Received: by mail-pl1-f170.google.com with SMTP id w23so13443448ply.12
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:31:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Besb79LnJR5BA/WeXHM2iIDDFjfxtveDj4JoUdHnS3U=;
        b=IVsCAoXngQoRiL8DBhFbidkvp6pTBxEHcGX/YaFRdH0ke7gYVbZGv+slv9ieugzwea
         XZplpia5Ryh4mWiaCVkV+y5kqIZI+IJwJ8FFTruGQrrmDskcIgnY3qG/5bImEPMViidf
         bPojbtaGGOEFuvVlwYm1O6/Ye+YWJ8St0JNQH1NyLWFVKCLowANmylPQbcByhLt02No9
         oKQnNDUBT5gf141WNapxoxfB8tdYsmK32TUEkvy0xD/UW0DHnfCtu8ByWQ3w7rL/sfOr
         kXHAYKxM82XtMYRi93TdeeH1Qur0S97G5bd/uIuT2uBGyew6wnRhoC3/iVPsMMF3H4YG
         07fA==
X-Gm-Message-State: ANoB5pmXUrGtmMR3AMs+g/0snR0GN86t8Mt79KToWNpgGrK1EQhlRIMZ
        M1LBYK7CWm+MEPP796sBVrA=
X-Google-Smtp-Source: AA0mqf4rMuxqPzpBsYPGKYZCo+vg1dJzaREihtV83vHsTGnrV2tNodo96eopO38wsQNs/qmBeAgI5g==
X-Received: by 2002:a17:902:c755:b0:189:47a8:e9d0 with SMTP id q21-20020a170902c75500b0018947a8e9d0mr15167826plq.51.1670880687632;
        Mon, 12 Dec 2022 13:31:27 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id p13-20020a170902e74d00b001896af10ca7sm6846275plf.134.2022.12.12.13.31.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:31:26 -0800 (PST)
Message-ID: <a9974eb4-fefd-e66a-6537-80e7ddd0f82f@acm.org>
Date:   Mon, 12 Dec 2022 11:31:22 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 15/15] scsi: Remove scsi_execute_req/scsi_execute
 functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-16-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-16-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute and scsi_execute_req are no longer used so remove them.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

