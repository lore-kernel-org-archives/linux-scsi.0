Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B57BAC64ED8
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Feb 2023 22:43:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjB0Wnb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Feb 2023 17:43:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjB0WnL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2023 17:43:11 -0500
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77F3D9769;
        Mon, 27 Feb 2023 14:42:19 -0800 (PST)
Received: by mail-pj1-f47.google.com with SMTP id kb15so7825811pjb.1;
        Mon, 27 Feb 2023 14:42:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6u8oq2oXvTRbMsEPSGA+QLZ+vr7GcOeYXtTa8jueGTM=;
        b=GNq1lHak6hKPbPr+5HjBjPMkzsgg3KASTfWP8Nl+8piCSVeJRs5qr9jMp8qhbvnSEB
         z+ewRuBmPpis+BALQfu0nLhuq4JOy1Aq88zUbjKolusfSufTtEtzTeBxVOPaEoQ2hDcj
         Sidw542BRaZLTXk/onYkmhmOHSIlp9ahTFsAd96z9ia8Z3Dx4Uwatl1f8C/0mZvwlCw+
         Yi0R6FGt7CSWD0V5KKcIKaFz906+LopA0QsatlUyiu6GLn+i5Gt+wf1QiCXVSem/vrOe
         g8uLjHDxFkTiGFVe/ivBKDbjivoRiu5U/3OMKyYA2MEnm0m7E0nLtolGVfTSMgxBS6Jt
         z57g==
X-Gm-Message-State: AO0yUKUCgl0lNXH5NTCOPlCW0auDkYyzEvpdTyWubXcma/ulwapp45Nc
        BoC4wbS4kQaiDs3UciPle0Q=
X-Google-Smtp-Source: AK7set/ht7zdEIgJouJZ9Ofe7q3lKZZEmj4XTuh5hFbe3Xy1z0z6jV+xr3cc0RfOBA2xBW+OFHDuvA==
X-Received: by 2002:a05:6a20:6983:b0:cb:aacb:312c with SMTP id t3-20020a056a20698300b000cbaacb312cmr1031666pzk.27.1677537667460;
        Mon, 27 Feb 2023 14:41:07 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:6cf3:f584:1162:e48a? ([2620:15c:211:201:6cf3:f584:1162:e48a])
        by smtp.gmail.com with ESMTPSA id v19-20020aa78093000000b0058d54960eccsm4662778pff.151.2023.02.27.14.41.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Feb 2023 14:41:06 -0800 (PST)
Message-ID: <6a076b7e-9b0d-11af-ecf8-8e3db96b4eae@acm.org>
Date:   Mon, 27 Feb 2023 14:41:03 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 2/7] scsi: ufs: core: Rename symbols
Content-Language: en-US
To:     Po-Wen Kao <powen.kao@mediatek.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     wsd_upstream@mediatek.com, peter.wang@mediatek.com,
        stanley.chu@mediatek.com, alice.chao@mediatek.com,
        naomi.chu@mediatek.com, chun-hung.wu@mediatek.com,
        cc.chou@mediatek.com, eddie.huang@mediatek.com,
        mason.zhang@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com
References: <20230222030427.957-1-powen.kao@mediatek.com>
 <20230222030427.957-3-powen.kao@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230222030427.957-3-powen.kao@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/21/23 19:04, Po-Wen Kao wrote:
> To avoid confusion, sizeof_utp_transfer_cmd_desc() is renamed to
> ufshcd_get_ucd_size().

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

