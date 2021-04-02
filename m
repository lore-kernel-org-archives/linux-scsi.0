Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BCF9C433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:49:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D8325610E7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbhDBDtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:49:45 -0400
Received: from mail-pf1-f181.google.com ([209.85.210.181]:43940 "EHLO
        mail-pf1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233701AbhDBDtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:49:45 -0400
Received: by mail-pf1-f181.google.com with SMTP id q5so2819051pfh.10
        for <linux-scsi@vger.kernel.org>; Thu, 01 Apr 2021 20:49:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=o56Mza2lmvXVo5BWhW9vqAcWpahryb8RHFwjpjAK7ts=;
        b=k11wGyQjzqirN6D/0w5+x62RKeDgkjhV4c7Xh1pEIbcuyRzLK/iI9NgTUkZvTIbaFf
         J+Knmm1xgbnwoP8MWz9J1cGgO+aMO35Pn354KvCo6F+MtjqY2QxvYGuYABwOFTQhLcMK
         m83sxMvDYAkR071pDM3SJ+7tnxiThUvQqUpcAINybVzXdtIeaX6gEHxwCpxmazK4Ok9/
         7IfRC2U/zjhOdXCevo0w1wO4yIGaW/1C5i8m/ARMXxFSieHTWnaGK95uuWy9LdUHfS2H
         GO2HATRFChwUFqUaDvh3xq9eBMmMJT8MGkbE8P6hxr7YRXbX3oO/Ui/h3i6Id4FstxcD
         GBDw==
X-Gm-Message-State: AOAM530oWxvO6TK3bhF2zmeNVzT4TaQJQqAWSoQn9gKTflds0ht62FTN
        PgF3/jtM7wxOBZKMxHefbz4=
X-Google-Smtp-Source: ABdhPJyoPjbCeaPONx7xK7aTR2RYPUFT2vgfehjQZU0nVwY7soD4ngYXpF/a9CLlj/Ydg4Kap8wn4Q==
X-Received: by 2002:a63:5004:: with SMTP id e4mr10200196pgb.61.1617335384389;
        Thu, 01 Apr 2021 20:49:44 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:2046:e611:bcdf:eb50? ([2601:647:4000:d7:2046:e611:bcdf:eb50])
        by smtp.gmail.com with ESMTPSA id p11sm6690617pjo.48.2021.04.01.20.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Apr 2021 20:49:43 -0700 (PDT)
Subject: Re: [PATCH v3 1/7] pm80xx: Add sysfs attribute to check mpi state
To:     Viswas G <Viswas.G@microchip.com>, linux-scsi@vger.kernel.org
Cc:     Vasanthalakshmi.Tharmarajan@microchip.com,
        Ruksar.devadi@microchip.com, vishakhavc@google.com,
        radha@google.com, jinpu.wang@cloud.ionos.com,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        John Garry <john.garry@huawei.com>
References: <20210330064008.9666-1-Viswas.G@microchip.com>
 <20210330064008.9666-2-Viswas.G@microchip.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <91bcde85-1cae-8767-4dc4-75ae88d3903c@acm.org>
Date:   Thu, 1 Apr 2021 20:49:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210330064008.9666-2-Viswas.G@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/29/21 11:40 PM, Viswas G wrote:
> +static char mpiStateText[][80] = {

Can this be changed into static const char *mpiStateText[]?

Thanks,

Bart.
