Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6492EC7618B
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Mar 2023 15:21:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231374AbjCOPVS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Mar 2023 11:21:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbjCOPVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Mar 2023 11:21:17 -0400
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A422653D8F;
        Wed, 15 Mar 2023 08:21:16 -0700 (PDT)
Received: by mail-wr1-f46.google.com with SMTP id v16so17712787wrn.0;
        Wed, 15 Mar 2023 08:21:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678893675;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=HCHm5BAbrrspNAkvTtbS1D4ARQ3US/XQ0mF7S3yD6NYelDY9rnOZZu/gdGoR2c8FZP
         2lRBphLvkq1iUb8F5qeYyqFmObybhJE0GIrwtg3lgiTA1xtX1t3vpHSZdd5jPdO/bSvi
         PM6gg2amBQAwlYgm5bWmxBVPX5aM5tfHmXTSXH5eLrLNuyj3jnrSiUH5mOaBbAjHSUOO
         RqrnluoFk9x+0uRZks9SccoPgYL/+isEf4+S80iuZDnbtQ32taG9NXBZlxqyQawc3W7P
         xHHr1MeNKI7bcuYc2ahHMD5/6csEoa7DPclD0Fi9Im3wv+X32uwYfSRI1jlSgpkFw06L
         1oZQ==
X-Gm-Message-State: AO0yUKVPDivhiO1LoKzAVKJsjD+X6/Gy78qA898gge/t2E1eMzrBAWMo
        dzEf0Eq+lbQGOF55d3xh8gs=
X-Google-Smtp-Source: AK7set8XwzdvNeHBY5z3hradfYk7oCFJwo3n7uKyUDx9TjYSH8kKZ/J2vcGdpEctyrcfLkbwPeX00Q==
X-Received: by 2002:a5d:464a:0:b0:2cf:f231:a477 with SMTP id j10-20020a5d464a000000b002cff231a477mr1897987wrs.1.1678893675123;
        Wed, 15 Mar 2023 08:21:15 -0700 (PDT)
Received: from [192.168.64.192] (bzq-219-42-90.isdn.bezeqint.net. [62.219.42.90])
        by smtp.gmail.com with ESMTPSA id j19-20020a5d6e53000000b002cfea3c49d5sm4605071wrz.52.2023.03.15.08.21.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 08:21:14 -0700 (PDT)
Message-ID: <6a6c8647-2d1f-dd60-6e69-25aafe312cd5@grimberg.me>
Date:   Wed, 15 Mar 2023 17:21:12 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 11/18] IB/isert: Fix use after free during conn cleanup
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mlombard@redhat.com,
        martin.petersen@oracle.com, mgurtovoy@nvidia.com,
        d.bogdanov@yadro.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20230309223312.94595-1-michael.christie@oracle.com>
 <20230309223312.94595-12-michael.christie@oracle.com>
From:   Sagi Grimberg <sagi@grimberg.me>
In-Reply-To: <20230309223312.94595-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
