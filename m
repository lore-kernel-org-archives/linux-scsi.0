Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9CD7C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 23:43:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241555AbiBWXnl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 18:43:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234743AbiBWXnk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 18:43:40 -0500
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF151CFDD;
        Wed, 23 Feb 2022 15:43:09 -0800 (PST)
Received: by mail-pg1-f176.google.com with SMTP id 75so229929pgb.4;
        Wed, 23 Feb 2022 15:43:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0T2ksM1hp0o5HnQja4gUE3uvR1fSe/G/R9C0d/6Xm3g=;
        b=ZFvn6s845J/aMlrktcBEdlA4aJWN+gzEwePh7WIJ4KUbrsfX/SvfxuiKDHEX1MMequ
         uRI539NNDZKnavPPvJkCr+yHD1Mo3fqhs9dTxQOdh3j4IRnOcJG6vHchWk1pZ/nG6lic
         LC0RMz2KVnL8I58BiJJZG8oI6T4x9JxAnheymV3ajSJCnG5OEsdEzVFF3mdzJ//CKzib
         usXj4ojj6MrmEdI9mPCQWnN1NWpj1s9Kw8xpY+D9YrzJnnH00COFA/exIUyOz3FQzN2f
         GXveN1FbpoN7SmnFZBMgvQTzTcFJ3/+pCClE464mnA7sGWWWy6JRs79366rEzIrRK4f0
         c+gA==
X-Gm-Message-State: AOAM531frJIad6DXmir/vUsbyNAyR62b2Tfm0TdH8z1xL3eD+Gxg7h3U
        sTnuHpWuvqIzt9B2wDtD2HM=
X-Google-Smtp-Source: ABdhPJy6SkO6zg9/FR8H1eyn78hZzH7bOtRlg3vbR1FX+AGjuAqXH/5LYwO1rUIoCtTztWW4BRcm9w==
X-Received: by 2002:a63:5110:0:b0:374:2312:1860 with SMTP id f16-20020a635110000000b0037423121860mr147753pgb.146.1645659788720;
        Wed, 23 Feb 2022 15:43:08 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id j4sm610850pfj.218.2022.02.23.15.43.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 15:43:07 -0800 (PST)
Message-ID: <b414cbeb-e2ec-b408-916d-a3cac15ec27d@acm.org>
Date:   Wed, 23 Feb 2022 15:43:06 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 7/8] scsi: move the result field from struct scsi_request
 to struct scsi_cmnd
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-8-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220222140443.589882-8-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/22/22 06:04, Christoph Hellwig wrote:
> Prepare for removing the scsi_request structure by moving the result
> field to struct scsi_cmnd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
