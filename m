Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D0CEC433B4
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:26:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6690360FDA
	for <linux-scsi@archiver.kernel.org>; Mon, 26 Apr 2021 03:26:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbhDZD1F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 25 Apr 2021 23:27:05 -0400
Received: from mail-pg1-f181.google.com ([209.85.215.181]:33734 "EHLO
        mail-pg1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231502AbhDZD1E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 25 Apr 2021 23:27:04 -0400
Received: by mail-pg1-f181.google.com with SMTP id t22so3919194pgu.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 Apr 2021 20:26:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XK1ousZSNXSp2Eo5uMoDLbzvTPgejQY6pQkaDePPjkM=;
        b=af820BJ9L/nmvFLtOVqf49I8II+Pi1xNlybKBhH0icGctG90ZVo+fRHDzVmWuA+O+C
         DYN1eiy85RIHi+PjM1dNTcGsGuU4lu+AAPrlN/ZadTXoUV5vz5B9+LHBg5Z/Yb4IMHWb
         UVfpecHnD1r0ny8Ap2tzSaTxDDauI9A6wSs5hrNLoMGyaa5IcO371JHKnL08mkS2yWrl
         2qIl/vRKqnRh0Uy60GKdFDfhyKugzrkGq8oHU1LjsMuIS91MzMY6pt0lBoAEDUZGbEfs
         J6k43R9uOrLBvTF/Gn3bFHO819qOghz7WUrazeOKI+jtAsevBjXTZomri+0GIpyOCyPg
         HrSA==
X-Gm-Message-State: AOAM530yjRsak5rLjR44JAaOQDa/OCsefgDFfWiacTp2IYokQvyC2Fcd
        F4M8FLmhQiTtErnGApCmjS5zUCW3C+puHA==
X-Google-Smtp-Source: ABdhPJzlZhxCTuVrJb/PUlLzc9YzP5RHR+lK6AjFliYNIcKijfQO+0cYR5qGP0FOFuxK7U1/agbJ1g==
X-Received: by 2002:a63:6f8e:: with SMTP id k136mr15461780pgc.326.1619407583468;
        Sun, 25 Apr 2021 20:26:23 -0700 (PDT)
Received: from [192.168.3.219] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z5sm9738890pff.191.2021.04.25.20.26.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Apr 2021 20:26:22 -0700 (PDT)
Subject: Re: [PATCH 05/39] scsi: stop using DRIVER_ERROR
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210423113944.42672-1-hare@suse.de>
 <20210423113944.42672-6-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <62e9af38-86a6-b81d-d78c-5ba6d644d38d@acm.org>
Date:   Sun, 25 Apr 2021 20:26:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423113944.42672-6-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/23/21 4:39 AM, Hannes Reinecke wrote:
> Return the actual error code in __scsi_execute() (which, according
> to the documentation, should have happened anyway).
> And audit all callers to cope with negative return values from
> __scsi_execute() and friends.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
