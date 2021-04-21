Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B9D4C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D04286140F
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 21:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240596AbhDUVOy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 17:14:54 -0400
Received: from mail-pl1-f176.google.com ([209.85.214.176]:46656 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236316AbhDUVOy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 17:14:54 -0400
Received: by mail-pl1-f176.google.com with SMTP id s20so6537381plr.13
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 14:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dUR2CY1fFpIWhHypE2ebtqGSea4zz78YKwBnZGN0Uhg=;
        b=kEnTtAYmIsZ3Zg7zkyeHooeFP1hl1YG+8O9Dsk+sL+AORZybWNGfkyS5JdaGprXlN1
         CcvfO8KDAK4zx0/S6tUCXSRgEYSCzVwM+lExPPpBxsvC0Ts/iM1cVnaCDpQfMCZuNt1o
         /Jn7hrIw/XWq8YfKlEfBqJPz8ynMs/+VPoMV5DgQFYXRDx5gVtpgYpFIZ0LdNSnzkFNa
         cLEqcHUHb5bfcYeRjONNd4KqfU6orL9q6t1VmBHVsn6OlKDh2lVIW073JShbsslIy2T8
         iTvJ/IaQrqNgu0CntZKIiZjA/flvdVrRM97wDaNhK8B9jHcKTOnyNaPqN8fbdCqIa8ic
         3Vaw==
X-Gm-Message-State: AOAM530HZwVfrmbaASvymiLsEhyXbM+nk26xb1t1qv9g5JFHxPNhl0/P
        sTBxvILOGBg704UiGrjivZ/pqljybx8eMQ==
X-Google-Smtp-Source: ABdhPJzdaWBUDYVCyu39aqVCYRwPxk1DOYHFscuESY8+ITa0zgC3IM5/Ijy1YjXRI1Gd5ab6QjvHAA==
X-Received: by 2002:a17:903:2c1:b029:eb:3000:2984 with SMTP id s1-20020a17090302c1b02900eb30002984mr36339537plk.15.1619039659206;
        Wed, 21 Apr 2021 14:14:19 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id bj15sm3032210pjb.6.2021.04.21.14.14.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 14:14:18 -0700 (PDT)
Subject: Re: [PATCH 41/42] scsi: drop message byte helper
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
 <20210421174749.11221-42-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <606c5be7-299a-224b-e264-06123587c78a@acm.org>
Date:   Wed, 21 Apr 2021 14:14:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-42-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> The message byte is not unused, so we can drop the helper to set
> the message byte and the check for message bytes during error recovery.

not -> now?

Thanks,

Bart.
