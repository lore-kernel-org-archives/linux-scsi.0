Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A551C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Oct 2022 16:32:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiJLQcS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Oct 2022 12:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229657AbiJLQcR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Oct 2022 12:32:17 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5E3F5BC;
        Wed, 12 Oct 2022 09:32:17 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id i6so11666810pli.12;
        Wed, 12 Oct 2022 09:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VvhbPzMxY7C+fWgQgoorwW3zKRHrUN91eusXjh+535o=;
        b=oGL0si+4GmF/BGk0tL9ytnndlSeJHt2OfzDssSIQxvmoMoxZarQFyl+qE9qQgHEmQM
         r9wmq2+jVKop3XRH1HpB60fjtL6kMYVd7cVRyiVNgHZdW+qWwkRAgQ+LKB3VPTlYzXTs
         nePRKdwkGKAhukZjcUQ9LIo1yxzFsXTOGRDDlANRaBjjE/wI8KHbtwcUM+mGXoVTh0v6
         Hn/ZIwJVKKWccGJ5e0uRLdJdAb3jhAB/Q4QzQWpK3cQlsI4L2H55BQGlNufrwBFPqaBq
         gjT+LBsSYvXCca481SxYWs3SlWkeubr7TlMYVW2Bf7wDSjSPmE6aE9xgBv5e0XXVE8Wk
         xsXw==
X-Gm-Message-State: ACrzQf3MZONDuQfWbUOaZwgnyJaFZDzXmFkSClWppqoA6eSeiiGyILDy
        6iyuPm2WjtYln+SMCjLoEdZ4/TJ2ctY=
X-Google-Smtp-Source: AMsMyM4+iVebIJjmZjOa1UpsvFAefY+xdWIu2/33yX0tkYA9CIaSpDXd+RbZDa2ln7Bp38uY6/dddg==
X-Received: by 2002:a17:90a:e00a:b0:209:1545:74a7 with SMTP id u10-20020a17090ae00a00b00209154574a7mr6304290pjy.72.1665592336481;
        Wed, 12 Oct 2022 09:32:16 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:9ed4:22b3:68f8:8e6e? ([2620:15c:211:201:9ed4:22b3:68f8:8e6e])
        by smtp.gmail.com with ESMTPSA id b8-20020a17090a7ac800b00205d70ccfeesm1649221pjl.33.2022.10.12.09.32.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Oct 2022 09:32:15 -0700 (PDT)
Message-ID: <3465e42e-a175-b294-ecc1-8e21a714b3f1@acm.org>
Date:   Wed, 12 Oct 2022 09:32:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH] tcm_loop: Increase maximum request size
Content-Language: en-US
To:     Nikos Tsironis <ntsironis@arrikto.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220929115504.23806-1-ntsironis@arrikto.com>
 <fde47e5e-119a-54ca-7cf6-5b58552ee2b3@acm.org>
 <0f25805a-cddd-51b3-92e4-032872cbc595@arrikto.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <0f25805a-cddd-51b3-92e4-032872cbc595@arrikto.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/12/22 07:19, Nikos Tsironis wrote:
> Should I make these changes as part of this patch, or can I leave them for a
> follow up patch?

A (thoroughly tested) follow-up patch is probably better.

Thanks,

Bart.
