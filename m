Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 319EFC77B73
	for <linux-scsi@archiver.kernel.org>; Mon, 22 May 2023 19:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235003AbjEVTjl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 May 2023 15:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235019AbjEVTjj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2023 15:39:39 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F450DC
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:36 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-517bdc9e81dso3480398a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 12:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784376; x=1687376376;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E/NiyBUNQN6CkF6aj4DN1C8F8wjzkWvvcCeqt2HH4sk=;
        b=bxJJY/ASjEw1aH6TTxr6x6zbXKV+xZ36Zda/ufSlCaHWxAc3gNTVvpcgsanpRNsOIr
         hm1YUya8Z8MrQU+kRou4//VV46C/z1B+aHqzWgvSaD1ITGQgaOiwFoQRmzNvDVNk46jT
         kFuYj8HOs8LRrrBHCps3Wueu2ocq6/WBaNlMhVbXFX1NtDF6YjJoWZpIzLQ/1pYm6B3D
         Kbo34deyDAlg7YGg++l78GNBVxwlL2xMXWPUB1vkgSAZ492svdO+24sOt2iqLfEuYavv
         hFHPTZj7PkIr9OrOtDtqtnW0pHV8XW0VwA4lafGybKI17MKDkbGLTt5606GJl8/jCugn
         BcFg==
X-Gm-Message-State: AC+VfDyyxoH68EgsrxRtHuC0a4Afxa/ozguPm/KS58m2S1nFqsCU83yt
        inJwNA1BBgj7XyWlY/1/Jkw=
X-Google-Smtp-Source: ACHHUZ5b8eaaE/s+TlKsBaNGb5jceAfzXaZVEDPUh5Y/9pf1kl8wrRHKjsHDMVJdAf3hnYDqLlBsOQ==
X-Received: by 2002:a17:902:c1c4:b0:1af:b678:5168 with SMTP id c4-20020a170902c1c400b001afb6785168mr3399534plc.67.1684784375679;
        Mon, 22 May 2023 12:39:35 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:642f:e57f:85fb:3794? ([2620:15c:211:201:642f:e57f:85fb:3794])
        by smtp.gmail.com with ESMTPSA id x4-20020a170902ea8400b001a1adbe215asm5214326plb.142.2023.05.22.12.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 12:39:35 -0700 (PDT)
Message-ID: <59ad7f1e-5c53-be7f-6668-a74d9860d19b@acm.org>
Date:   Mon, 22 May 2023 12:39:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 0/4] UFS host controller driver patches
Content-Language: en-US
To:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <quic_asutoshd@quicinc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230517223157.1068210-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230517223157.1068210-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/17/23 15:31, Bart Van Assche wrote:
> Please consider these four UFS host controller driver patches for the next
> merge window.

Also for this patch series, please help with reviewing this series.

Thanks,

Bart.

