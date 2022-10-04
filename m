Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C158C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:34:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229981AbiJDWew (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:34:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229674AbiJDWev (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:34:51 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A296554
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:34:48 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id r18so737909pgr.12
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:34:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=7M2sfOVNz2S3KndO1AOXo6QP9q2n7/Ho1bnhiutTCgFvvLW5DYFshZy08Uz3aDlD8/
         jhX1ngkofYGFWWxQp5dk3f7tYpqNJ4RdHldKheTwge2vYOXfq4J7Ph8cv8HCrSHqxzb8
         TzQRBlIheMmrwHChNc3mtBsopsbn766GMxyeujIbG5Ep5tnQJLqAVvkDHGhsFLJecnwB
         Ggzv9a46C3Vf9i/v3jFsj8vnHRq+2vQh/B4CnrDtXRpGo2FgxCvZeRYnIXPIVAqe9Rfw
         vBoAnqTjslOVN6WuQATm4cW6T/N2Y3pqtUujJHbyltKtK/aak2j6hsCoaGXyjYGOfzZ1
         T6xA==
X-Gm-Message-State: ACrzQf13QSqgLENpPEqZ5S2vNsWFQ+0dTzQAfwK3xZbqpBJ++ivfZ9PL
        QAvBOCGJgQLKMsvFOgwX5APcOhx4A4U=
X-Google-Smtp-Source: AMsMyM7pTYNPKX0YUB6Ep+0afRHGUOenJvNdzC7K3xp5KO4tGfHPC/EnfU394mMGzwvKRyUdmu7cMA==
X-Received: by 2002:a05:6a00:1503:b0:546:833c:ed05 with SMTP id q3-20020a056a00150300b00546833ced05mr29549138pfu.44.1664922888249;
        Tue, 04 Oct 2022 15:34:48 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id c11-20020aa7952b000000b0056183958089sm3929224pfp.167.2022.10.04.15.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:34:47 -0700 (PDT)
Message-ID: <4498e353-a5a7-df51-00af-3127144869f2@acm.org>
Date:   Tue, 4 Oct 2022 15:34:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 08/35] scsi: scsi_dh: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-9-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-9-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
