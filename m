Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D7ADC38142
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 01:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjAYBlO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 20:41:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjAYBlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 20:41:12 -0500
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558914A1DB
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:41:12 -0800 (PST)
Received: by mail-pj1-f49.google.com with SMTP id m11so5157582pji.0
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 17:41:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sG4ozEg9IBA76Fj18+t3iMfOl9gHD0y7SCENIGb/guU=;
        b=mO59k49XF/3Qer+vA6HSK6KbeipnsNiVlf4GCJMrW3wx7tQlP+oanznRBbF8u94xM2
         3I6HmWuSsW5rdjPdZuJXHm3u2+zdpM0irqbpgeydZiPyQM1Yiv6kIg0rgbHZOUrAWc11
         ly2OLWc9xXWfxVHQmzaJ8WK2ya0NeO7JNihYdthmGW3rnjY0RYFA3VwHkqmeIzKK4bMq
         KtkgAyOzyQC7F0ms6d3oybSEmvGwWrj4KRlToUQdOuXorBuG9Y9B5ByoqfKDEmnAe04c
         bAdm3HiB8FawDGHqVHDdqad6Se7ez+osTGNelLKmcMYa4y+7t7uk1vsb+T4FR64ZOnRD
         pI9w==
X-Gm-Message-State: AFqh2krkEDR4kLozA/BLPWM8eZkO4G6X7knbbS1cF0tklEu0mtXHqeKg
        4RASJxi0fokby5/2PVQMVk8=
X-Google-Smtp-Source: AMrXdXst9z28tWrFOSPkgrBWIxc8Jkv2VCGV5pYT9s923RY4fKv3FxnkKPsmdQwEb8wvBRx5eeNPoQ==
X-Received: by 2002:a17:90a:6e4a:b0:223:f234:6a3 with SMTP id s10-20020a17090a6e4a00b00223f23406a3mr31301035pjm.49.1674610871696;
        Tue, 24 Jan 2023 17:41:11 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id mv17-20020a17090b199100b0022be311523dsm205038pjb.35.2023.01.24.17.41.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 17:41:10 -0800 (PST)
Message-ID: <4f9794d2-00ed-22da-2b4b-e8afa424bf17@acm.org>
Date:   Tue, 24 Jan 2023 17:41:09 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: The PQ=1 saga
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Li Zhong <lizhongfs@gmail.com>
Cc:     Wenchao Hao <haowenchao@huawei.com>,
        Andrey Melnikov <temnota.am@gmail.com>,
        Martin Wilck <mwilck@suse.com>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>
References: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <yq1lelrleqr.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 16:01, Martin K. Petersen wrote:
> I would like to revert commit 948e922fc446 ("scsi: core: map PQ=1,
> PDT=other values to SCSI_SCAN_TARGET_PRESENT").

That sounds good to me.

Bart.

