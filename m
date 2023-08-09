Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF92C001DE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Aug 2023 22:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbjHIWFM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Aug 2023 18:05:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjHIWFL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Aug 2023 18:05:11 -0400
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2A1B18F
        for <linux-scsi@vger.kernel.org>; Wed,  9 Aug 2023 15:05:10 -0700 (PDT)
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1bbff6b2679so2830205ad.1
        for <linux-scsi@vger.kernel.org>; Wed, 09 Aug 2023 15:05:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691618710; x=1692223510;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8YuiwCjReinxYPzmnDwt1gexvNsLycJ+90B7YjdIDIM=;
        b=LlcN4HPPZSeirpZLJCG6/M3iN4IFNVQo1/ly35z7jOH3Z6c+Cz2jJDSsdr//nrmPnP
         FpqCZh5ENLhTRuh/gmYwERbu92Qvs3Oi/zsAMqWNRPB8OxO7IgUfnS1LyUJIBb8NZVFq
         W02B3FAiXuRTm6xU32pYeJtAMe7vjFZEthpoDU/7gBWEjK+UVeUnEiSK8eNX3IJc6KMR
         JbXdmd/PQeo3lD/hMMVVBd5fTtL3xtKve78MXkqOg/o9FhfYnJWzryGbkgMT+oWHAXqm
         +C6jR2Qzi0PnHp0OOdAg1pBmpY7yE+z3PbHdIr2UZ4x0eHO1pBE9TBmFF1ZxHul8tcIb
         iRWg==
X-Gm-Message-State: AOJu0Yy6kYeImeyL3klKNhDkbftsL9lw4VNwRfqfY7jr6xOP7gcflKNv
        QSOK22PMt1uJSmXmuqJdjig=
X-Google-Smtp-Source: AGHT+IGkGKy+EKWYk4nDXCT5kG0MJm7QxpqQvHq7UNFix9vyw2OiGiaQf339STix8YTrZHfPiiBzhQ==
X-Received: by 2002:a17:903:1cc:b0:1b9:e9b2:124b with SMTP id e12-20020a17090301cc00b001b9e9b2124bmr323316plh.64.1691618709928;
        Wed, 09 Aug 2023 15:05:09 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id w18-20020a170902e89200b001bb9f104330sm18881plg.240.2023.08.09.15.05.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Aug 2023 15:05:09 -0700 (PDT)
Message-ID: <f2d04a08-0342-c53c-85fa-c121c7535a24@acm.org>
Date:   Wed, 9 Aug 2023 15:05:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH -next] scsi: Remove unused extern declarations
Content-Language: en-US
To:     Yue Haibing <yuehaibing@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20230809142107.42756-1-yuehaibing@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230809142107.42756-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/23 07:21, Yue Haibing wrote:
> These declarations is never implemented since the beginning of git history.

declarations is never -> functions have not been

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
