Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AA4C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 16:10:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239180AbiECQNf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 12:13:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbiECQNd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 12:13:33 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3387C3191E
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 09:10:01 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id 15so14380740pgf.4
        for <linux-scsi@vger.kernel.org>; Tue, 03 May 2022 09:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=VcBhKSgWBYb/aXivVYSamFjkv/D2j4yVy25Gd5vWbUQ=;
        b=cUg77EwF3egCGxAGOCi1YCMIUzK39a/ACIVEVsejIg6KrdlbyOePyxmqoT7YRTxhIt
         HqIS08HRPdhaljqaRq7ibZtDtBI1Czv8Ozg6qUBA+7mVMq3K6qECRjFvQaPLg8Sc8ZiF
         T/rJ44fsUzDDgYZDlPSGmEKHG4xRL7QFQeh5gn4B1aC7d4qjNFxu0fKYiabNb8sgaZmu
         3pE8HSqw0vL6TVzZJHH0QXgsUklf9rvZ/YUPT6UKFlVqonh2+SiwqtkZeEVFagT/C2//
         un/OBpuy/ZXhOb58tFCh/t+oeScNm2rg1p+Ztty8m5eBBvN0nw2hdhSNHak5x0J9X6D4
         aSfQ==
X-Gm-Message-State: AOAM5305YS7XRXABy0FfZrE9Z0XRoxVrmW56cmg8++OGD99ExlGXwjCB
        7uwvl5kGqCMKEYfxEkZZroQ=
X-Google-Smtp-Source: ABdhPJwP6/T++F/cSraNcPVUFY/6gvIAVvXgqzLii3JrzMM/1s9tE58um1nRnjFffEWygIC/cFhSwA==
X-Received: by 2002:a05:6a00:2382:b0:50d:fa40:1077 with SMTP id f2-20020a056a00238200b0050dfa401077mr7340835pfc.8.1651594200671;
        Tue, 03 May 2022 09:10:00 -0700 (PDT)
Received: from [10.10.69.251] ([8.34.116.185])
        by smtp.gmail.com with ESMTPSA id p12-20020a1709026b8c00b0015e8d4eb2e8sm6477597plk.306.2022.05.03.09.09.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 09:09:59 -0700 (PDT)
Message-ID: <5cb298f4-57ed-9ed9-1e01-23723343ce9c@acm.org>
Date:   Tue, 3 May 2022 09:09:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 02/24] fc_fcp: use fc_block_rport()
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20220502213820.3187-1-hare@suse.de>
 <20220502213820.3187-3-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220502213820.3187-3-hare@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/2/22 14:37, Hannes Reinecke wrote:
> Use fc_block_rport() instead of fc_block_scsi_eh() as the SCSI command
> will be removed as argument for SCSI EH functions.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
