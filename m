Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 860C8C54EBC
	for <linux-scsi@archiver.kernel.org>; Tue,  3 Jan 2023 18:09:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238652AbjACSJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Jan 2023 13:09:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbjACSJX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2023 13:09:23 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB27311477;
        Tue,  3 Jan 2023 10:09:14 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id w3so1809607ply.3;
        Tue, 03 Jan 2023 10:09:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ac3xtbao5DPMoj5S4yU2TyUQ2d/DM13Gadih/Ls/XWI=;
        b=Du1Au1uJNDKPIKiKCZ8PAK9XJHE6ogAv/ZSObFtbh+x3PZlSrNLUwokLuUI4mdH7np
         O1C0cGdSdZS3e1LLvxYKvYKCV/1/DDQ6F8H9yl3KG9/mvrV2sHf8Z2jETkmG2gGCUJd6
         XNIxPx1K47kSEaUhqhbbn+WDHwI5C21AfhY4Jy6fQ97QKGkGX1wFrY1W2q5+p0MXNjWG
         GSy+FPvIVIEgTS29b3fRgRYSFmujA11UJZ5hdfemDB/8YPK1M3Z+bpZVA1wwTZ7kg3WE
         /IUK1fwr3CSc66O8YnuAMaoFuy4+h9B3uFpEOIFM/ZLTjsf4jm15PBSrxNysyGtouewF
         7Wkw==
X-Gm-Message-State: AFqh2kpKqbXo+p7Twz9K1mgLyVtKvVXmil0HZPGCUWiSKXJCcDNWPloq
        cxwvaKgSGb2NI1K5TsnpCtI=
X-Google-Smtp-Source: AMrXdXuvRVrhezbxvTauVXRucMNArg/EM5bY7vftUrFEUyc2jqjzQFawPwDxhmMrfk4H5XlLwX/qgA==
X-Received: by 2002:a17:902:c144:b0:192:e3b6:7410 with SMTP id 4-20020a170902c14400b00192e3b67410mr1182712plj.28.1672769354265;
        Tue, 03 Jan 2023 10:09:14 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:7da8:fef9:8c31:bf89? ([2620:15c:211:201:7da8:fef9:8c31:bf89])
        by smtp.gmail.com with ESMTPSA id q13-20020a170902edcd00b001928c204428sm2819292plk.142.2023.01.03.10.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 10:09:13 -0800 (PST)
Message-ID: <d7323ee3-643a-8785-060b-c30eeac30f6a@acm.org>
Date:   Tue, 3 Jan 2023 10:09:10 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v4 2/2] scsi: ufs-unisoc: Add support for Unisoc UFS host
 controller
Content-Language: en-US
To:     Zhe Wang <zhe.wang1@unisoc.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, alim.akhtar@samsung.com, avri.altman@wdc.com
Cc:     linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        orsonzhai@gmail.com, yuelin.tang@unisoc.com,
        zhenxiong.lai@unisoc.com, zhang.lyra@gmail.com,
        zhewang116@gmail.com
References: <20221209124121.20306-1-zhe.wang1@unisoc.com>
 <20221209124121.20306-3-zhe.wang1@unisoc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209124121.20306-3-zhe.wang1@unisoc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 04:41, Zhe Wang wrote:
> Add driver code for Unisoc ufs host controller, along with ufs
> initialization.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
