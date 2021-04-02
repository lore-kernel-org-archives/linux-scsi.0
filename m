Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F67EC433ED
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3827061155
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 16:01:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbhDBQBf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Apr 2021 12:01:35 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:44978 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236392AbhDBQBf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Apr 2021 12:01:35 -0400
Received: by mail-pl1-f173.google.com with SMTP id d8so2690000plh.11;
        Fri, 02 Apr 2021 09:01:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=adQrXD/QMPMSZKmlrv3Spu5lFtnFhcFlL3hMBNKAdAI=;
        b=qeipdfER/dQ9TJmwanDpKc4nqbQjmOIseHg4znVAM4l4r/IUlAL0eLTIsUICm56SP2
         6KAqhPknBEC360h5jKO8P7NR59b9nSUj5bOrABn+gg6eSte48bRuU1tmmUmT5eC30bsU
         S22/U6++89H2Afn5iQEjUKdA8JkKFF3EGrOthgITCiU3VY4wb1vEiaoql9Z/RzEMmEpX
         STNWpvV630Bact/ZfinB6wIjmuBrRNxpHoXs+DZUQKVJfU58aPiJ1RoaZMMe2Hlf3P6R
         jtyw16mXPodhEgJYYpItbIh16kLnvPoYHc2FenyFSNoM1xMOoW0tBGVhx7qxhiUop1A7
         wa+A==
X-Gm-Message-State: AOAM532QU4sPz1ad5/msF9tG/2uq3cL6F6Ls2twuVeuq48yIhn6OztP2
        ipGyAx32MmxxkOFhsd81RMQ=
X-Google-Smtp-Source: ABdhPJwr5y3pa4+4QNdHE/Wgcx2VHDwnvYu/mTS5q2sagYxua7Ji4WITexSx24K4/x2yEH7aTUzBSQ==
X-Received: by 2002:a17:90a:e50c:: with SMTP id t12mr14126664pjy.138.1617379294014;
        Fri, 02 Apr 2021 09:01:34 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:b5d6:3f29:a586:36e2? ([2601:647:4000:d7:b5d6:3f29:a586:36e2])
        by smtp.gmail.com with ESMTPSA id y193sm8841859pfc.72.2021.04.02.09.01.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 09:01:33 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] scsi: pm8001: clean up for white space
To:     Luo Jiaxing <luojiaxing@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linuxarm@huawei.com
References: <1617354522-17113-1-git-send-email-luojiaxing@huawei.com>
 <1617354522-17113-2-git-send-email-luojiaxing@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7f8aef00-07bc-6b63-19a1-85a8153387cd@acm.org>
Date:   Fri, 2 Apr 2021 09:01:31 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <1617354522-17113-2-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/2/21 2:08 AM, Luo Jiaxing wrote:
>  #define AAP1_MEMMAP(r, c) \
> -	(*(u32 *)((u8*)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
> +	(*(u32 *)((u8 *)pm8001_ha->memoryMap.region[AAP1].virt_ptr + (r) * 32 \
>  	+ (c)))

Since this macro is being modified, please convert it into an inline
function such that the type of the arguments can be verified by the
compiler.

Thanks,

Bart.
