Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08B7DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Apr 2022 17:11:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245420AbiDRROE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Apr 2022 13:14:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243248AbiDRROB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Apr 2022 13:14:01 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBFF8205E6
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 10:11:21 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id q3so12859552plg.3
        for <linux-scsi@vger.kernel.org>; Mon, 18 Apr 2022 10:11:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SJJ182evwvKczflNrdphi08b4tzWwOrc6MdUHYqpjsw=;
        b=odaWvGqd9gnI/e1s2t3xopUFEKLvuIIY0CX/znkG3rJ1TPyDWVWl0pfSEBs+rREnyD
         30vB++mrriTNb2tJYPEZTMU+SnuC0YW7nJrG88/rWCxpV2GxxRLXSiKG66a5LgLsKTSm
         jh2KPWkUoWUgIKviiAnZIFVHtJ9DQVrxYkq260EI90a9jAPFnwA5Hbeu8PflNzCSrrZ5
         qsbIcRCOJaeLCukD+rRegpoHtPJP/JYD4hYXZAWp3V0FZcyhk+HOI77qxr5CkpeEUA30
         bAkMF7G6QHLZ2iF3tVLu4Fxh6q0ZqFcWTlARRnq5DjkZFjZ9RFs2tvFuKIautbedgL0N
         KHEA==
X-Gm-Message-State: AOAM532xvasnJMfFuvkL/2Dfn2eWqztNBq8eq21mt4EwE968itw/L5fr
        fbMWpEAboEZeMJ34iw3rSik=
X-Google-Smtp-Source: ABdhPJzgv2f3slZDqxOzW02Tc+5tbyEFhgZScvP2Nm3hlFLjAOSHslcVC9L38GJ+k350cq/EBKG3Xw==
X-Received: by 2002:a17:90a:ff17:b0:1cb:a182:9b05 with SMTP id ce23-20020a17090aff1700b001cba1829b05mr14058953pjb.1.1650301881191;
        Mon, 18 Apr 2022 10:11:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:713b:40eb:c240:d568? ([2620:15c:211:201:713b:40eb:c240:d568])
        by smtp.gmail.com with ESMTPSA id p12-20020a63ab0c000000b00381f7577a5csm13214251pgf.17.2022.04.18.10.11.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 10:11:20 -0700 (PDT)
Message-ID: <492cd10d-9964-6a5c-2896-9fc0d5397a54@acm.org>
Date:   Mon, 18 Apr 2022 10:11:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412183228.3729720-1-bvanassche@acm.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220412183228.3729720-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/22 11:32, Bart Van Assche wrote:
> Split the drivers/scsi/ufs directory into a ufs-core and a ufs-drivers
> directory. Move shared header files into the include/scsi directory.
> This separation makes it clear which header files UFS drivers are allowed
> to include (include/scsi/*.h) and which header files UFS drivers are not
> allowed to include (drivers/scsi/ufs-core/*.h).
> 
> Update the MAINTAINERS file. Add myself as a UFS reviewer.

Can anyone help with reviewing this patch?

Thanks,

Bart.

