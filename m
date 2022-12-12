Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C026C4167B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:05:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233250AbiLLVFU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiLLVEt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:04:49 -0500
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 338EB186E2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:04:21 -0800 (PST)
Received: by mail-pf1-f169.google.com with SMTP id g1so808939pfk.2
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:04:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Km7IpMVnDhYBjkPKcZBm90Rib+oKap7eCZ1UEcIn9hI=;
        b=VT0pIIK9DpMYGFZH7GQUtK1VfdhNx/Mgpu9zQuyfarLuQfHU3/QxVGmfRmr3YwcNZ2
         dmxLyRGFWNd+BVZieBdZVif8Rbam3lxRbr12PbpH2Lez3gXVRLPQC+dZx1r0IUnG8VnM
         psDcsCPkM+cR/oxj2LlJ+1JRPMZDZCoAi91UWylIU/qNb/J7mRgoh5otMzQT8i1xMY1j
         bDhOpiafHfKgXtqto+K8VWAn7RZOYoBslW3JnzvnusjMWOPB1Nz/hieTgWIFUAWQXW36
         8JIXqunHJlglmEEYbEe2Y2RANfdZgSnCrLWSabz8uODKm//59+uNJ9i91CjPyCtNT51q
         HiyQ==
X-Gm-Message-State: ANoB5pkXmV2sq/oolrmVfDS8iaHsEpy8sgO0wQarMbBc4vgdYiKKpno0
        txpfMIxEnP3c7SlT0xz5/AE=
X-Google-Smtp-Source: AA0mqf79XwKg5X6ejRB+soKFkZX3eRmclLljE+LKvQ9An28j3kUa+E07JGRizZrbt1UcwYsoHV4fFA==
X-Received: by 2002:a62:1611:0:b0:572:745c:2907 with SMTP id 17-20020a621611000000b00572745c2907mr14323338pfw.18.1670879060467;
        Mon, 12 Dec 2022 13:04:20 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id p127-20020a62d085000000b0057447bb0ddcsm6227758pfg.49.2022.12.12.13.04.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:04:19 -0800 (PST)
Message-ID: <642dbd57-9376-ec6c-ca5a-22f05cfcd78c@acm.org>
Date:   Mon, 12 Dec 2022 11:04:16 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 06/15] scsi: core: Convert to scsi_execute_args/cmd
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-7-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-7-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Convert scsi-ml to
> scsi_execute_args/cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
