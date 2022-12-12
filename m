Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8860C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 19:46:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233364AbiLLTq5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 14:46:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233361AbiLLTqz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 14:46:55 -0500
Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5091411465
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 11:46:54 -0800 (PST)
Received: by mail-vk1-f179.google.com with SMTP id bj2so475991vkb.6
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 11:46:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ha6sp3V+2K0fqvCYK3OHD+8grxygEf+Eg0V8d1X0KY8=;
        b=64BSVPCfaGMrUv8HMh9jL6rcYgzTG1lFZEOug1EIG1NtJxcmTHOt1NJ0xTPBg98A39
         /2WWf2rHDW6/fGCsGzCQrAysxfisUf95dU7ZlPGug9bkx8QxiDc7oNMPHFMB93ukvDVN
         NKemknaXiao5B253zPLwUpxzrmehjP0gd5lFPHRq4VwMXKUxbYBPXAcEhYLxp5CRDT3A
         TtIMrMcs7aPrBw7VGNcy3H5yqKHyvLe425r3HpCwqfaif1My/HYweb+YtwxGyxGY125Y
         3ldCp5hCr7rya+Vzrm/k4JmiNEqKSuB7a32W5NEesYrbaJfmo2ZR0uD7RLt4YKerJtmm
         MbPw==
X-Gm-Message-State: ANoB5pmJR+jQEwQT9Ix+Fb1hvhSaAHpRafoI9wHw54LaMz+iXfj8ZSHB
        yaSKgpUgOMzRzvXjsVcjNJajeZa/PmM=
X-Google-Smtp-Source: AA0mqf4zxu6uFP+jg1M9qb5xaGCsR/YVwclTc+fAaLYPU19aV6Yt0jQEtMZVvpAx5ZLriTACuwL6EQ==
X-Received: by 2002:a1f:a705:0:b0:3af:2f12:c9d2 with SMTP id q5-20020a1fa705000000b003af2f12c9d2mr8068221vke.3.1670874413280;
        Mon, 12 Dec 2022 11:46:53 -0800 (PST)
Received: from [172.22.37.189] (rrcs-76-81-102-5.west.biz.rr.com. [76.81.102.5])
        by smtp.gmail.com with ESMTPSA id x5-20020a376305000000b006b949afa980sm6120585qkb.56.2022.12.12.11.46.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 11:46:52 -0800 (PST)
Message-ID: <c379d53b-f6b5-410c-ac40-03551e809906@acm.org>
Date:   Mon, 12 Dec 2022 11:46:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 04/15] scsi: ch: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert ch to scsi_execute_args.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
