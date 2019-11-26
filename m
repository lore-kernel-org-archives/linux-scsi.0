Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 455F0C432C0
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:56:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1BBB12084B
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:56:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKZU4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:56:54 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40922 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726033AbfKZU4y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 15:56:54 -0500
Received: by mail-pl1-f196.google.com with SMTP id g6so318188plp.7;
        Tue, 26 Nov 2019 12:56:54 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fP7qiShWnhxiuCzTU49Z46t4ZKNcqE48uI8LEzVdLvw=;
        b=GwqaF9N8cQnQAzLJyVs68095K8bLGGFNjKsM/HwptIrtKQaEKkbwhvyg13IdGX/+l+
         7fd+jNMi8tW62uUMzEwcyW9geSQ/AHTHBpVOPJcGAB3F/g7LgzxLjTl50mG8DvzK+tmY
         kxN+AwaPQ1apCsNPDWB15M0m1MQi0/HDHvF3P5/cdyOzSP8M5dL1N12ILzFukQA/WTsD
         Spp7mVsGEWNxMmak8aDzbH7CGVC/b0l5QBn2+2yrr8mj+2hJ/uRNUO1gF405nP7aSLco
         3WYRkHwrpDBaCvz3QlwB2HYfeH9h3jMSmnf3HidyxQDdBx8HDiW+EOOiHpqWqgVfwR6s
         VyfQ==
X-Gm-Message-State: APjAAAWL7+fPR9Rq4BvST5v1JCS58XdNsYqZeJlsBE2DUisPqqX5oXA3
        hXsIgTYdicoJK11gm8Iyt0c=
X-Google-Smtp-Source: APXvYqxXIM2JI+uTbJfgDYlbkp4pka/G5RqtcvpAaX8gcxLRrbZqN78TybtPgykj8EJcK+1JYpX3PQ==
X-Received: by 2002:a17:902:7089:: with SMTP id z9mr291401plk.292.1574801813581;
        Tue, 26 Nov 2019 12:56:53 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b1sm3607150pfi.74.2019.11.26.12.56.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:56:52 -0800 (PST)
Subject: Re: [PATCH v3 00/13] scsi: qla2xxx: Bug fixes
To:     Roman Bolshakov <r.bolshakov@yadro.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     linux@yadro.com
References: <20191125165702.1013-1-r.bolshakov@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <347fd571-89d7-2b7e-fd88-1711002c3fb9@acm.org>
Date:   Tue, 26 Nov 2019 12:56:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191125165702.1013-1-r.bolshakov@yadro.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/25/19 8:56 AM, Roman Bolshakov wrote:
> The patch series contains fixes for qla2xxx and solves two visible
> issues: [ ... ]

As explained in Documentation/process/2.Process.rst, please post patches 
outside the merge window.

Thanks,

Bart.
