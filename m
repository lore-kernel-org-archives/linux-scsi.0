Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B0EBC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:11:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239204AbiECQP0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:15:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239192AbiECQPZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:15:25 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2656E381A3
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:11:53 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id x23so9811837pff.9
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:11:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=c7k55TolvjnXwtSRnOH5OVAhDpa6R9JScBYJd4UbNkA=;
        b=Vbaf27qYQsUTT8iNME+jy/mLW35HcpVXte1jWVoB6cAlkFos4MhEHS9EtGDKiaZe+z
         cUuDNoYhvSxKZ9G+D80rrcR654pfH2ZabZmW9V2tvBQQMOCwN3Ig+a1LvTTvDRIA4tt3
         cM+d6unJSTPR/BEZGrpy06nxaUfsfbX7VJ6YHWCySY178W+mpml4Jl8edSQoTzijV6nR
         IK798CaAJyH7qMyGR+xhHsX7uPp6QKf/f43ybWQ5pUiKgd0gKGx37LcHYmNpw/i5PE/L
         wrh3G3CjLIAbrQlFxjwmR6dCEwb3W8Z+6z1gN/aIZcQ5OBebkkkQlt/VLeCeAgA7YkmM
         WGnA==
X-Gm-Message-State: AOAM5326IA2yzKa+T31XKfdITQ6L2F+CXrX/S3SRCTm0EgK5L2LsCKHF
        hzs2ss3rmg3YHpDbGAR5z2Q=
X-Google-Smtp-Source: ABdhPJxnVtwGWBVsqIqoElrW4FPJTjLUqxwPULH5V3MXVFutxESNNlgNJ49G8Ts6vj8NUZ2CfB1YOw==
X-Received: by 2002:a63:87c3:0:b0:3ab:5ca7:1763 with SMTP id i186-20020a6387c3000000b003ab5ca71763mr14249467pge.552.1651594312564;
        Tue, 03 May 2022 09:11:52 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id b12-20020a170902d88c00b0015e8d4eb2d2sm6550018plz.284.2022.05.03.09.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:11:51 -0700 (PDT)
Message-ID: <89a46c6d-abae-28fe-2f8f-83dca5e03e64@acm.org>
Date:   Tue, 3 May 2022 09:11:50 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 10/24] ibmvfc: use fc_block_rport()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-11-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502213820.3187-11-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:38, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the latter
> will be deprecated.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
