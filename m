Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CE6EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:42:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230111AbiJDWmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:42:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiJDWmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:42:10 -0400
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A84C96E2EA
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:42:08 -0700 (PDT)
Received: by mail-pl1-f179.google.com with SMTP id 10so10282659pli.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:42:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=Yy05ZKLJCEMqJKGOr25bcq4aYFxn9M5skw3qLGPkiJivOMpJYrFxbCDIX/xp5BqiSj
         zGxXeZH/Gaoti/1ZLhV32rPGPAVnBjkmAVlgyUKZW/D5XBZwK2E0NDtaMhoGRCaHva0n
         LFgxXPd53FQLplYr03VLWXzhgiF2qdwTIKN2BUm0/g922r7/eFVuLB0gNA3P2IEy2pZy
         Y1jUvgTgzJekDc+ui2SqHk0z5UMSZ9a5Iy4GVwgYwfZo/rmHpvMpsuvT5HLgsUZPUWIw
         i5Jxjh35VqzFLxpZCfm9QcXdfcFOeZyBBXYN7KusnDprvSzr9UCmnE3s5724/feynBQS
         l7uA==
X-Gm-Message-State: ACrzQf1cA1wYr0m0x1Y32SjRcuST5PDH5n44LGvdqsCzEWEjQE5lpJUh
        nqT8Efr1M5wdZ5GYMKvh/7Y=
X-Google-Smtp-Source: AMsMyM45qO0iIM4sn3HpWT5SNB3Vaw5yfjJsz40NSbJngxSlH+zIV/Qi8aA9HxqowQCaK4Q895vWPA==
X-Received: by 2002:a17:90b:2651:b0:20a:daaf:75f0 with SMTP id pa17-20020a17090b265100b0020adaaf75f0mr1868124pjb.142.1664923327520;
        Tue, 04 Oct 2022 15:42:07 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id om12-20020a17090b3a8c00b00205f013f275sm67109pjb.22.2022.10.04.15.42.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:42:06 -0700 (PDT)
Message-ID: <0ba11432-1142-e9ab-f442-1b9b0a2c9107@acm.org>
Date:   Tue, 4 Oct 2022 15:42:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 10/35] scsi: spi: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-11-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

