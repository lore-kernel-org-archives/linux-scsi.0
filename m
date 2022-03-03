Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E517DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 01:30:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231336AbiCCBbS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 20:31:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231325AbiCCBbS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 20:31:18 -0500
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C2FD1A12A1
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 17:30:34 -0800 (PST)
Received: by mail-pg1-f182.google.com with SMTP id w37so3170407pga.7
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 17:30:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gF1TmK1AMzzwfkMJwZvge7fqnaIdyb1cd/8rjW76YuU=;
        b=SaWBR9Iq4Tuff3u6qoAvtAHVPa2jWyepkhTN/EMpTfWnrtII9MtPMFhUaAPswdTTA/
         s5E24LTu0Zl0z0Hkyj4QVK+QE0pibtCgBYuZZ7veIXr0dCgvp2aKHDZXm+hhQVVTjDSK
         9Hm03JE1XlI5PMjX+lHiefS98t6BUnpNyzBP3SFGlujrVAJaR7r3sQw018SG0lVimeBQ
         fjuM43cYSCkYE5uSrl76N0djOOLqYez08UIN31p+xjf19/eTzkMwwulI7XRtZ9n/IO53
         NueYLEy1YnAAq49ehpK9ZbCX6d/Udb1E6j4BwFWF5DSkD6psRnfgg2MVth5fyVm8lUom
         NEFw==
X-Gm-Message-State: AOAM530ztUKcPE6QUKk+a01xJ4uG9UYayhYx/Ok3jEQ/hs5PACHZ0QmA
        O/w0Nsoie09oz0MER35RDU8=
X-Google-Smtp-Source: ABdhPJyvAZz9IJT+ebGVkel1PE828OyzdhybGlEaNCEWl5/UmVmjKgDygZllpKA1/H/2UF7OmYA2Pw==
X-Received: by 2002:a63:f03:0:b0:374:50b5:1432 with SMTP id e3-20020a630f03000000b0037450b51432mr27576975pgl.308.1646271033654;
        Wed, 02 Mar 2022 17:30:33 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id w17-20020a056a0014d100b004f1063290basm440288pfu.15.2022.03.02.17.30.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 17:30:32 -0800 (PST)
Message-ID: <2562b7dc-70aa-a9db-c4c9-3eb43fb5cc22@acm.org>
Date:   Wed, 2 Mar 2022 17:30:32 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 05/14] scsi: core: Cache VPD pages b0, b1, b2
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-6-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-6-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> [ ... ]

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
