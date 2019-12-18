Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99B68C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 17:28:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74C05218AC
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 17:28:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727367AbfLRR2m (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 12:28:42 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:38797 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727184AbfLRR2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Dec 2019 12:28:41 -0500
Received: by mail-ot1-f67.google.com with SMTP id h20so3390969otn.5;
        Wed, 18 Dec 2019 09:28:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nWpDQmZNg8zKVk12QskQ7NNS05C4fI/JmZBKLdKyu8Q=;
        b=dZRMOMeNC/Q13lGDTit6eg4tCnW8gL3yVs3ofur+1d69N9Jte5Hz50eLnMEu73SVwk
         bWzuopI7VqsYWhVqX6ffW0IFARYuox02pceF2slWjaZCz4bs6H/DMlxVNcolZW1hAxw/
         y29gcmwU16IyuGHhc8ckd6K9YnOcohQn3uFrgFDANTa44XUuwpBreNscZjY4o3LIJf1T
         3UOOKuDLy91sJDRRPAyqAhHQ1KAjpiGrKH+VrDfg67H0pnXavYyyXOXvhFjRkN8LSUkl
         8ARXPYu6Rcs1w+vfnekP6np22XfzZ5sJHx+0BQ0tAXuKDvBaXzpa+MsBKI0Dgz98t7bL
         56Xw==
X-Gm-Message-State: APjAAAVy6w9/eHivqXPiW0gWkxZpQpDk0SWJc31iAMOsOZrARQpgcrau
        FqOTqLkf1HdSwLXPEz9LbXYulUPp
X-Google-Smtp-Source: APXvYqwhO/YiuZqs+xO2NHkyoOldc28Kz+sBRmtSa/p35vQFTsCzm9COIsi+E45pkGXSZnXiADpwAA==
X-Received: by 2002:a9d:6481:: with SMTP id g1mr3875467otl.180.1576690121236;
        Wed, 18 Dec 2019 09:28:41 -0800 (PST)
Received: from ?IPv6:2600:1700:65a0:78e0:514:7862:1503:8e4d? ([2600:1700:65a0:78e0:514:7862:1503:8e4d])
        by smtp.gmail.com with ESMTPSA id m11sm994380oie.20.2019.12.18.09.28.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 18 Dec 2019 09:28:40 -0800 (PST)
Subject: Re: [PATCH] scsi: target/iblock: Fix protection error with sectors
 greater than 512B
To:     Israel Rukshin <israelr@mellanox.com>,
        Target-devel <target-devel@vger.kernel.org>,
        Linux-scsi <linux-scsi@vger.kernel.org>
Cc:     Max Gurtovoy <maxg@mellanox.com>, Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <1576078562-15240-1-git-send-email-israelr@mellanox.com>
From:   Sagi Grimberg <sagi@grimberg.me>
Message-ID: <a55aa32c-4500-f0b9-f149-b8418690d015@grimberg.me>
Date:   Wed, 18 Dec 2019 09:28:38 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1576078562-15240-1-git-send-email-israelr@mellanox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
