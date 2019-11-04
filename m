Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C116CCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:43:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9825620869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:43:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfKDRnM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:43:12 -0500
Received: from mail-pf1-f182.google.com ([209.85.210.182]:44070 "EHLO
        mail-pf1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDRnM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:43:12 -0500
Received: by mail-pf1-f182.google.com with SMTP id q26so12726022pfn.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:43:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=U/Yab5OcXCf8VX3LTJtcfq3p2ZOQ+jYOo9QDK0OWOO0=;
        b=gmcGmOCVZXW58h/GV8IzE5GhAaY71xVc49Oz2UMlWDeAEbo0n2MMzMuUWJjbOFqIvu
         mBnSnWGTwue1GSgVypUb5wo+vQnDh1YIMNY9WfL8uhb94SwqNaQ2IASS7fPAWboRoCXO
         RlFkmlN1MhtV+ZVPTdo36KZzr8y1+zrYnbjQ/7d6qrFo3qWdmcvPFz50xZ+a/ZAEjVNT
         gGF0l/We8htiNM57zRcopO93xgNi3WozADEykUU0CtMAcHbWZmxbhpJRBxEtcBLdL7i3
         D8wo+7PaN+WsDvEVZ+D1yZY+UgqFmFeS1mKTtl2UH5KQURQuVXcJQ2nfj/JGWv20M4hG
         vAzw==
X-Gm-Message-State: APjAAAUiZGfIYFOYOI5+qagEOPcq2wME8eJRLoTWbNiqoig1XRExb6ox
        m6lkl5lF3p/Y94FOzWZEExtFdWiS
X-Google-Smtp-Source: APXvYqxjf7QgcIMQxSU3A/3fv0tr8GEwXk2/B217NMk7LC23wavUmXqQezy25ldA9aX26eO4cedrCw==
X-Received: by 2002:a62:e519:: with SMTP id n25mr32295598pff.144.1572889391259;
        Mon, 04 Nov 2019 09:43:11 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id 21sm18250764pfa.170.2019.11.04.09.43.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:43:10 -0800 (PST)
Subject: Re: [PATCH 17/52] qla4xxx: use standard SAM status definitions
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-18-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <7d535ccc-227c-0cd4-0785-bd0b6b68edda@acm.org>
Date:   Mon, 4 Nov 2019 09:43:09 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-18-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status definitions and drop the
> driver-defined ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
