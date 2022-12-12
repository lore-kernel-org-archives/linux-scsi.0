Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C0E7C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiLLVaS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:30:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231752AbiLLVaQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:30:16 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CABB2DC1
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:30:12 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id v13-20020a17090a6b0d00b00219c3be9830so1370328pjj.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:30:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9/owdIpGdRN4Uged7j/QsHChMB9PhFA1wcFPU0umqQs=;
        b=o32TM0N88dyBESmVtkOJ9yPOg2tYpgKA8IVEUlxrlcqWozt85No0ryjrFxyIn8qxMF
         E9zpgOWRRmBlPG/McuHouB+XoLK5YbCK3aJOMy4n2QCaPIc65FzgaB83ggKdHZTu9nzR
         KxM/Cf6Nyyu/VIJ7IFAy3GzFPG2jwgPBVbn6fbE/FTTrN+DSGmIVRLbPA5XDVsHPacBz
         R/Q9g0OJ6ltbASdfalFAkGOI8kr3m4VyYyCpTk4b3kB8rU0TqiSpyJMpzmy9/8+5lllm
         g3cW+K9ktvDcRZYd2FtsV7gUKdeTc1jl0des1q8C8/HT0Mll2oivdAOBWTyN5APXyUKP
         ahkw==
X-Gm-Message-State: ANoB5pmw/WIQDk5qnt0dAE/lOtu6t59wsHqFrwURPMpryQ7SeToqFVeE
        ioirYDh4OGsINK+j+vRzkeg=
X-Google-Smtp-Source: AA0mqf6+fZ7xBnYoO/LXh0EEcs5w76pCDUVDtJLnBsvTt/DqffXKf7u/fXRi2580VwFNC/6IGrvMfQ==
X-Received: by 2002:a17:90a:430a:b0:218:fbb6:d040 with SMTP id q10-20020a17090a430a00b00218fbb6d040mr17695598pjg.4.1670880611481;
        Mon, 12 Dec 2022 13:30:11 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id f27-20020a63555b000000b004785c24ffb4sm5564771pgm.26.2022.12.12.13.30.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:30:10 -0800 (PST)
Message-ID: <f99c848e-3a35-6c17-9787-8616fea35d95@acm.org>
Date:   Mon, 12 Dec 2022 11:30:08 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 13/15] scsi: target_core_pscsi: Convert to
 scsi_execute_cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-14-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-14-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert pscsi to
> scsi_execute_cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

