Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A2B9C54EBD
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 23:40:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231229AbjAHXkq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 18:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbjAHXkp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 18:40:45 -0500
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58AD310566;
        Sun,  8 Jan 2023 15:40:23 -0800 (PST)
Received: by mail-pj1-f54.google.com with SMTP id o8-20020a17090a9f8800b00223de0364beso10991720pjp.4;
        Sun, 08 Jan 2023 15:40:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aSpsWrXJfBg68rx5ebvZJ1VDSNR4IRkVbz99lzlH66o=;
        b=WEe/LJ7HDr8ZklF999jVMAE0k+lGnRFFaDNkHrKvg2ngJjePn0101mrZQJJpb5zDNp
         PuNnpVQdvEHw+BP8wMcwiDhyILEemrkM/OyGZxXj1m3o08to5h8hNen+oM49hlWfo1Z9
         5fpdldtM2r527dQpSAzdmvJWYaq5WPfcuzy2eDwop4OwvOsUV+dKL8WzBGxoIT5qodgX
         wnGsD1ZdG+G5CJLAqmBql+mMdkS9US6Ez9cbKRkMbnAp6/D5czSwixCBTHUHXE+xMEtD
         qWIGrU2rwdbdIEXBWyPZsABsHS/qC997CBDMpbh5Q/LXbZVWAoWSHl74wafHLxJezAJb
         FqwA==
X-Gm-Message-State: AFqh2ko+x6vJRQYIqj5hSWcjn+A3DR2rkTs1dn3svQ0vOsJyfCcae7L4
        7LgPAE5xFkuXCeBQ1YDeq1I=
X-Google-Smtp-Source: AMrXdXvxoJkajP6OPO7YWgY41e11NI+SxAug0wlOqSZMf+SPUffR/T0+ZgBTolRa1gfQo8+YiMLPsA==
X-Received: by 2002:a17:902:f80c:b0:189:a934:ee3e with SMTP id ix12-20020a170902f80c00b00189a934ee3emr72416345plb.62.1673221222742;
        Sun, 08 Jan 2023 15:40:22 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id q5-20020a170902eb8500b001801aec1f6bsm4654584plg.141.2023.01.08.15.40.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jan 2023 15:40:21 -0800 (PST)
Message-ID: <c948ae95-e543-7a03-db76-711eed624b94@acm.org>
Date:   Sun, 8 Jan 2023 15:40:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 0/3] Several compilation warnings fixes for UFS
 Advanced RPMB
Content-Language: en-US
To:     Bean Huo <beanhuo@iokpp.de>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        quic_cang@quicinc.com, quic_xiaosenh@quicinc.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230108224057.354438-1-beanhuo@iokpp.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230108224057.354438-1-beanhuo@iokpp.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/8/23 14:40, Bean Huo wrote:
> These patches are to fix several compilation warnings introduced by my commit:
> 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg"),
> please consider this patch series for the next your merge window.

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

