Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E77E6C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:54:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5C8C6143B
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 20:54:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236458AbhDUUy7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 16:54:59 -0400
Received: from mail-pf1-f169.google.com ([209.85.210.169]:33755 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235454AbhDUUy7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 16:54:59 -0400
Received: by mail-pf1-f169.google.com with SMTP id h11so12384371pfn.0
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 13:54:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8QEl39Lhf+NbRGHFlzeYUG7XmqCm5IsoIYkJkkxGl/0=;
        b=SOKI0RMxycILRLgrim+aoLtiIRjLrQBey/iZJHD04zkT8diHkbab+BiBYq/OLQhw4Z
         UFMX1/7GWqInQwi0KYOkoNKE0aPVyewYRS4489340rPYkjsHOvo1MFo6tPFuKTS0MVp6
         zu6LULzYDmHg6nGNZrigrMZ0yPTAaj85CrOJoqz9d+WnJBiu1p8lycepAbLDm5eu7FgQ
         Dgoi4zuRxmpV6PJ6YB1mCEa/SGOA2mcQ5McEQY1QLCsQAnlNw5ocC1qii2oAt8qoT3PQ
         KJUrPM/jAKn7pfx9qevDs8OcuN+CDfz7OTC2X5hOWZUoxTgb64zopzy+1QmC3QJy0zBS
         CzBQ==
X-Gm-Message-State: AOAM5327TTUFio/XBo6qZ2WICy+LugwIeZUuX7EaVieewGKCrbbv2q7P
        64eTS+crxOJwiHwmq/j+MUwsbk8WP/kSGQ==
X-Google-Smtp-Source: ABdhPJwylvMst8mDMD0+zrvnoiBTDipeIX9eFnnlfPWLZlD4Qa+OBEeXEX2p4F8OZzCgoKvNQRP+mw==
X-Received: by 2002:aa7:9d88:0:b029:25d:90d0:9de0 with SMTP id f8-20020aa79d880000b029025d90d09de0mr19876607pfq.17.1619038465198;
        Wed, 21 Apr 2021 13:54:25 -0700 (PDT)
Received: from [192.168.51.110] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id k21sm166385pff.214.2021.04.21.13.54.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Apr 2021 13:54:24 -0700 (PDT)
Subject: Re: [RFC PATCH 00/42] SCSI result cleanup, part 2
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20210421174749.11221-1-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <f830015a-974e-a6d0-d375-c6140e8dba1b@acm.org>
Date:   Wed, 21 Apr 2021 13:54:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210421174749.11221-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/21/21 10:47 AM, Hannes Reinecke wrote:
> This patchset is the first part of that, and is intentionally posted
> as an RFC as it directly competes with Barts patchset.

I'm fine with this patch series being merged upstream first.

Thanks,

Bart.
