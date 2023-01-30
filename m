Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE267C636CD
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbjA3VjH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjA3VjC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:39:02 -0500
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A12241FF;
        Mon, 30 Jan 2023 13:38:33 -0800 (PST)
Received: by mail-pg1-f174.google.com with SMTP id 7so3739825pgh.7;
        Mon, 30 Jan 2023 13:38:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=i0CsG70S5pMLnYQW5IXO/vy/AI12mcu7+9FITNJzwKY=;
        b=1bJSickQRfeRNG0rmXBjrqe8itoCOxPOyorlmOu57i+9PCioYlSkUsp+zl+f7ntN8Y
         P4DV6iGbv3MFEM7PsCNySEVB6/La2/xncCLnIf5pyhmKfIl5eT1Cs0ZStQ32t2qwgRbJ
         sBksELA9ZSsRWHR2I5OWq+ffpVh7s1uv/M09bHJSjefAhGcmM0f0ywvEikAWWefxZXKp
         YAc0RkN/hhmXHSkreTnMc1pSV+djDgq+hMGVINqPfo8uvQP5FtcrqLAoaZxIJoyvAsA6
         XfXaOAgos9E70t52+/9A2hu9kZ8t+HWrBEE/3H3WouzGiDhNbwDx5Hl5UWrP2bGwQpFU
         3EPA==
X-Gm-Message-State: AO0yUKVxbVuRvFDNaUMh0e6mB9Ud8xJSzQ9FaAVfja1dTcYYZ1nmy+Kq
        57aGniYlEa4giNP8+1uhzvhgrRlZinRZ1Q==
X-Google-Smtp-Source: AK7set9BjaxlHKPCjSwppXCSmzp+4eUJxJ+4PrOk1fuGoK5FPq0dhPpofrtWcWZY7Khm0i6TWucvMQ==
X-Received: by 2002:a05:6a00:a04:b0:593:3c37:fa75 with SMTP id p4-20020a056a000a0400b005933c37fa75mr17436663pfh.1.1675114711350;
        Mon, 30 Jan 2023 13:38:31 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:5016:3bcd:59fe:334b? ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id i11-20020aa78b4b000000b005892ea4f092sm8156276pfd.95.2023.01.30.13.38.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Jan 2023 13:38:30 -0800 (PST)
Message-ID: <83f740ac-39a7-9dac-4a39-05a2fda8544f@acm.org>
Date:   Mon, 30 Jan 2023 13:38:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Content-Language: en-US
To:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Cc:     "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
From:   Bart Van Assche <bvanassche@acm.org>
Subject: =?UTF-8?Q?=5bLSF/MM/BPF_TOPIC=5d_Support_block_layer_limits_below_t?=
 =?UTF-8?B?aGUgcGFnZSBzaXpl4oCL?=
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

While increasing the page size increases system performance, some 
embedded storage controllers have been designed for systems with 4 KiB 
pages. Supporting such embedded storage controllers in the block layer 
for page sizes larger than 4 KiB without reducing block layer 
performance is challenging. I propose to hold a session about this topic 
during the LSF/MM/BPF. Kernel patches that implement this support are 
available here: 
https://lore.kernel.org/linux-block/20230130212656.876311-1-bvanassche@acm.org/T/#t

Thanks,

Bart.
