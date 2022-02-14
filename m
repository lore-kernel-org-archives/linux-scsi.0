Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0EBBC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 16:51:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237348AbiBNQvU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Feb 2022 11:51:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232355AbiBNQvR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Feb 2022 11:51:17 -0500
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEF164705A;
        Mon, 14 Feb 2022 08:51:09 -0800 (PST)
Received: by mail-pl1-f179.google.com with SMTP id l8so4987741pls.7;
        Mon, 14 Feb 2022 08:51:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3yPbiawnoTewdDNHiKDHgRuYxsSFY5JgTKHU0YNYk+4=;
        b=4ToBIDeI5/xdIALMjKOuXaPD+SkC8KPT4zzXBhm+Q8CF79JyUHA9r8A/C1iDs/fo+C
         /I+DImQeNpUkWsubaECABbfPrzBG6Xzgah+Emy2sTbIXmxvK138ST+0DUSigBnfhU0uh
         Y67StdVzyxfKSMCUdhidszgUYJk4TEl+Sub9RRZDzQej2ldMp95Ebh+XLprxs5Yxbn3g
         Fy02caxtWNl+WXUNDqtNDCXSzbdnwqI0F5GJvrRpt5hS+uBzTeUovg0UL2e6KNKLJ5Cs
         MzljSmjuov1lLjRKsDspqsts06AzGhgr6Q5u8Awvy2AzSRDo2JNuGNVYRaSRs5EgZ+mN
         mTMw==
X-Gm-Message-State: AOAM533PzbB0wJyd+cOApc3R2BoOuikaTgg+ziLZsAfbBD/MuPGWOkUM
        ERwZ9Rw+trEdNyNInin53ko=
X-Google-Smtp-Source: ABdhPJwsrKAwDeIspFDEGq40H19o8morxFVhKT7pdp2J4OJhnqcHHcCZhMHedkitoajGiPQ5m2bX2g==
X-Received: by 2002:a17:90b:295:: with SMTP id az21mr15646456pjb.145.1644857468936;
        Mon, 14 Feb 2022 08:51:08 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c12sm39145563pfl.130.2022.02.14.08.51.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Feb 2022 08:51:08 -0800 (PST)
Message-ID: <974edf4d-37fa-b25a-d0ac-33ac502381d8@acm.org>
Date:   Mon, 14 Feb 2022 08:51:05 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] [hpsa] Fix the wrong chars in comment section
Content-Language: en-US
To:     James Wang <jnwang@linux.alibaba.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        storagedev@microchip.com, martin.petersen@oracle.com,
        jejb@linux.ibm.com, don.brace@microchip.com
References: <1644742790-87210-1-git-send-email-jnwang@linux.alibaba.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1644742790-87210-1-git-send-email-jnwang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/13/22 00:59, James Wang wrote:
>   /* Find and map CISS config table and transfer table
> -+ * several items must be unmapped (freed) later
> -+ * */
> + * several items must be unmapped (freed) later
> + * */
>   static int hpsa_find_cfgtables(struct ctlr_info *h)
>   {
>   	u64 cfg_offset;

Has this patch been verified with checkpatch? The style of the above 
comment does not conform to the Linux kernel coding style. Please fix.

Thanks,

Bart.
