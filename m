Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC3F6C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:12:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF45F61090
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 02:12:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbhEDCNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 22:13:42 -0400
Received: from mail-pg1-f176.google.com ([209.85.215.176]:36835 "EHLO
        mail-pg1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229801AbhEDCNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 22:13:41 -0400
Received: by mail-pg1-f176.google.com with SMTP id c21so1113014pgg.3
        for <linux-scsi@vger.kernel.org>; Mon, 03 May 2021 19:12:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z+nwthoA9Z/n8oMuXXjo2UkABT4svB1saI3pV9us0fo=;
        b=YRBDPGQ9RX3a+oFOjeclXNV5COSUvhCAHw/l5XKObwYgbOOLBcTzBONBHMBcy9tnRg
         LzvtgwvbiSUAV84w6BIlAitlgIQA+QJ2vcr0V15QyvJ5LK9Oyd31nmCDga/hZj6Rq/4a
         WmMHACkFnO+/5qUov0UiQ9+40gBTPGp4Q9UnJEQnnkHqcmBpkAK23QVX6nIxB46VnOGJ
         1TwLVbHKtEIbXeJjW8T67n2crjZc8y0kwp9YXSfbmzT2uvA91WG/GB1vwQt5cjeB6mLk
         N0nTJ5ojXPZg9l5MBKHiRpb2t2NO96L1eCOP7EI+//G7NtrJookwFcaE8c1OnpqwgaY9
         dKeQ==
X-Gm-Message-State: AOAM532BsjXNJcnb+2J5X/NxP5X+2tpIgHi8J+Etp+vvsGmSzrBNg2Im
        STP7YlknfToPNDgFNxrI1L06ZaTkTHg=
X-Google-Smtp-Source: ABdhPJzvImOMnpRv2rRanIjsXTZAQ5F5h+2ziy2nWtisbcELm/Yuzye2Pyrk9pYJmpNkOMH/N+DI9w==
X-Received: by 2002:a63:160a:: with SMTP id w10mr7188358pgl.225.1620094366275;
        Mon, 03 May 2021 19:12:46 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:6b81:314d:2541:7829? ([2601:647:4000:d7:6b81:314d:2541:7829])
        by smtp.gmail.com with ESMTPSA id 132sm10311594pfu.107.2021.05.03.19.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 May 2021 19:12:45 -0700 (PDT)
Subject: Re: [PATCH 01/18] fnic: kill 'exclude_id' argument to
 fnic_cleanup_io()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org
References: <20210503150333.130310-1-hare@suse.de>
 <20210503150333.130310-2-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <5f64a82f-4d2a-6b0d-1560-f829d5cb1b09@acm.org>
Date:   Mon, 3 May 2021 19:12:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210503150333.130310-2-hare@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/3/21 8:03 AM, Hannes Reinecke wrote:
> 'exclude_id' is always SCSI_NO_TAG, which will never be reached
> when traversing the list of tags.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
