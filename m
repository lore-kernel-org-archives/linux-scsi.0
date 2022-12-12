Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D9BEC4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232753AbiLLVTD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:19:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233635AbiLLVSX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:18:23 -0500
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6414028
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:17:56 -0800 (PST)
Received: by mail-pg1-f171.google.com with SMTP id v3so9099851pgh.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:17:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qf//pZe8bPDvx6QL4M8G30k8JR4LBdk3mrv0zxjJN1g=;
        b=3F+2sI5B6xbZVHfJoasAXPtt0w30PHof0iXUR7Jze279WDk12mgJ7d+WUClaJpK+Rb
         cHuwlhYGCUOM4+zTNfuURN9RImvzLEjEjW3GQOltEfF/X+c1+iZsh7uQiT8awyxccSYC
         zu+U0OriHHr/i3UyR21cqiU6gPNRE8awmrl9QSeDe2tOqcVPHqWAxdpsbRhO+lLVJ7/I
         uTlpiVPp/hdytB0w7f+52r9al+SymafIOdiYN5ioJtBhqIK9G+U0IlDXnFhae3ZyMGQl
         /fYgZVUGR3vKn2Z8f6vqBYaZ2vt40W53aS5kEg8htLmdFgM5j5ufikubmRDDtSRn/pGc
         s33Q==
X-Gm-Message-State: ANoB5pkDyIy6jwsSehmx/sFbw+BoA3BpYiJqYKlQpNQifORfA4VewO5e
        TUQn98gj5oRjnDc4hGkYBCk=
X-Google-Smtp-Source: AA0mqf5TiyQAVekjAptG0AdQSLg3RJdc6eS8cPXEBq6vriUVUMjXEZ8PAipy2BQ7PxOiO4CUaapf2A==
X-Received: by 2002:aa7:864a:0:b0:56d:1bb6:af75 with SMTP id a10-20020aa7864a000000b0056d1bb6af75mr15365199pfo.4.1670879875836;
        Mon, 12 Dec 2022 13:17:55 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id r17-20020aa79891000000b00576f7bd92cdsm6437383pfl.14.2022.12.12.13.17.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:17:55 -0800 (PST)
Message-ID: <d7c2a1db-8ac1-e846-bd5d-eb204e9e73e8@acm.org>
Date:   Mon, 12 Dec 2022 11:17:53 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 10/15] scsi: ses: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-11-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-11-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert ses to scsi_execute_args.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

