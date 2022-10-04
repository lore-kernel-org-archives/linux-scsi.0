Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1B99C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:50:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiJDWup (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiJDWun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:50:43 -0400
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F281D6F251
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:50:42 -0700 (PDT)
Received: by mail-pj1-f43.google.com with SMTP id x32-20020a17090a38a300b00209dced49cfso218160pjb.0
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:50:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=VkPuS7TptRo9RMI0E6kxwAnV2Gz3Qwy5bG1nTQp9Ufw=;
        b=y3z417gPcdwa+aTAHWAf/JBywYG/1vTdZRqeQkplGQjZMoNG3K/UCx1uJm1CNrc0hQ
         NGjhL97pdJ+2b/0HjibRADij+qFJBwbP+09sN+LHbivvoUitnznZdRTSlXg1bUF1uqya
         GpLboaL8ZSMhNRu9Qx1rQlZVLwRHW9CUjSo1yiokWYoOI9U+848YQnoKZ8ZIyqEnr5I4
         hSObmljjdW1/InGTPhpMnS76TMbYVa0aVyIF82ruMe9YwRC8GTln12uJ7kPNbj8x4gfS
         VU2toBeMS/QV2UxZHjiI4gxRWNxzNywDKGjLhmU0YhgbDR+k2+Q9JeB8GbVRcDD634jE
         NJug==
X-Gm-Message-State: ACrzQf1dikCPuD+Xvu+PSSC7m3YRTeAdq8EjRUkZadQznL5xKmA47SPH
        tz4ZBECTy/J5MzxaRcMYoM8=
X-Google-Smtp-Source: AMsMyM5fflEDmfvAD3P39gwTpnDlnApqupxNLgN/PuZ4i+SKlmMCzTmZW6472mfZAAAE4+ugnY8sZg==
X-Received: by 2002:a17:90b:3a90:b0:202:d341:bf81 with SMTP id om16-20020a17090b3a9000b00202d341bf81mr1906677pjb.179.1664923842440;
        Tue, 04 Oct 2022 15:50:42 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id u8-20020a17090a3fc800b001f333fab3d6sm74327pjm.18.2022.10.04.15.50.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:50:41 -0700 (PDT)
Message-ID: <88ac36c3-94da-3dcc-b341-bbcb985cf136@acm.org>
Date:   Tue, 4 Oct 2022 15:50:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 19/35] scsi: Remove scsi_execute functions
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-20-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-20-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is no longer used so remove them.

is -> are?

Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
