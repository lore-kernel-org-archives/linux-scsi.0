Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03373C4332F
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 19:01:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiKITBZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 14:01:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiKITBY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 14:01:24 -0500
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3921E19C1B
        for <linux-scsi@vger.kernel.org>; Wed,  9 Nov 2022 11:01:23 -0800 (PST)
Received: by mail-pf1-f175.google.com with SMTP id i3so17542311pfc.11
        for <linux-scsi@vger.kernel.org>; Wed, 09 Nov 2022 11:01:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4C8P5UDp/4eSlWCPSB6cRuaF/QcakH7Bxk10HvniyJY=;
        b=0ADB+wktr0UAG9NXNY0gjG5+eThM4p2W/UhtKH87iAilMCROE1QOq2PvYOATAQEMmm
         tVdDFr0DN4dc9NkAPrZoiri4XltatL9P1TuIja4GiFEeHsUoEQ1T6hoEAvLxli7Th5Eg
         nH3+qy/F+A6nUPScuXT2GEHk6+HnK0Arjuynuxh3NNbhxn7tBrh+XULZcUi0o85qxpjH
         p9E8BnZXkGxb3GjgP4rE0SRkFTWLuINgD287cE/FfjCDrWmfkiMLqwHmHIVr8SXS7Ab+
         sbwC0n9QuCJzJajICddPmUymHohWwclSkCWcpsx1vt+XrLyGCRm9U5ALeI2hXuWPYrOw
         qIKw==
X-Gm-Message-State: ACrzQf1DlRfhB1jwfOonsmK4aBFhG6s2sopA8M0IfLXSfuYSI+nMHrWh
        Cy3is2YW4AzIJbWxUHIwwWo=
X-Google-Smtp-Source: AMsMyM4NNDOwCIzhJ/UPRqp0VO9VfejsloMrC1aU7iUmZ6s5tiZgLYXKr8OmaTIZtqC8bDV35goe8g==
X-Received: by 2002:a63:4949:0:b0:442:b733:2fae with SMTP id y9-20020a634949000000b00442b7332faemr51567336pgk.424.1668020482636;
        Wed, 09 Nov 2022 11:01:22 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:68b6:5dae:a00c:c3b? ([2620:15c:211:201:68b6:5dae:a00c:c3b])
        by smtp.gmail.com with ESMTPSA id s4-20020a170902ea0400b001869ba04c83sm9535789plg.245.2022.11.09.11.01.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 11:01:21 -0800 (PST)
Message-ID: <b13313c8-ea15-86a0-80a3-a8701c9c61ea@acm.org>
Date:   Wed, 9 Nov 2022 11:01:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v6 35/35] scsi: Add kunit tests for scsi_check_passthrough
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221104231927.9613-1-michael.christie@oracle.com>
 <20221104231927.9613-36-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221104231927.9613-36-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/22 16:19, Mike Christie wrote:
> Add some kunit tests for scsi_check_passthrough so we can easily make sure
> we are hitting the cases it's difficult to replicate in hardware or even
> scsi_debug.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

