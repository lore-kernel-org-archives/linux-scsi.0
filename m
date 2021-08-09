Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55B94C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 21:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E61F60F55
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Aug 2021 21:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbhHIV5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Aug 2021 17:57:43 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:46788 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbhHIV5l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Aug 2021 17:57:41 -0400
Received: by mail-pl1-f173.google.com with SMTP id k2so18103288plk.13
        for <linux-scsi@vger.kernel.org>; Mon, 09 Aug 2021 14:57:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3aPm5YLAD1kJXF8sjPtt6iDFT3xvszHRATpOLfro8gI=;
        b=BXxp7RwiPEmnzNVpdsluhGqkTy7JiztePMhx80F5CMHNB1qSmeSgcah4hXDcnkCX/X
         plgFVon8C5YbpJCOc74lBzHTHGs5+bbIJYiEdAm/t/f263YT3lcRym8TF3VPkglzX+YX
         Z5UewuSGtPcMXKIpnPiSUo5yO6I12Lx2coWgsZnUn8kQFqiJUucl89KsxVBlKL30owW6
         S5nmEASgj1StmALve5yQsHueakvPkP8NJYzZ9LGhbGQsXIVMfTeGxXklXH4po92LzBlO
         qKwitlijQPPZ4z8EZzDt/F05dHQc/AlHxXkQMbh1i4YMGM5zI4CYCB2CCRtmm80puaCT
         x+wA==
X-Gm-Message-State: AOAM530kd6LTC87fdWSSiXX4ryZgTHkoTU/lrql9nZLgnwqwrsK7kKWh
        ZM3+c94J306AG09BivBQMzCDMin5NaA=
X-Google-Smtp-Source: ABdhPJzQ7LG8DK1kR50XoZrluxvZkIdW8/Er/YGA8YtEV+N7ZjjIhbjXr5LqHALh75DKYv6wC7WV5Q==
X-Received: by 2002:a62:e714:0:b029:3c4:8544:b2b7 with SMTP id s20-20020a62e7140000b02903c48544b2b7mr26073596pfh.5.1628546240368;
        Mon, 09 Aug 2021 14:57:20 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:7dd4:e46e:368b:7454? ([2601:647:4000:d7:7dd4:e46e:368b:7454])
        by smtp.gmail.com with ESMTPSA id y12sm21124146pfr.68.2021.08.09.14.57.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Aug 2021 14:57:19 -0700 (PDT)
Subject: Re: [PATCH v2 2/5] scsi: isci: Use the proper SCSI midlayer
 interfaces for PI
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210806040023.5355-1-martin.petersen@oracle.com>
 <20210806040023.5355-3-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <fe157cc2-ee8c-58fd-a18c-1bbd753d15ea@acm.org>
Date:   Mon, 9 Aug 2021 14:57:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210806040023.5355-3-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/5/21 9:00 PM, Martin K. Petersen wrote:
> Use scsi_prot_ref_tag() instead of scsi_get_lba() to get the reference tag
> for a given I/O.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
