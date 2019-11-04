Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B123DC47E49
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C9D220869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729452AbfKDRwQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:52:16 -0500
Received: from mail-pf1-f169.google.com ([209.85.210.169]:41216 "EHLO
        mail-pf1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727989AbfKDRwP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:52:15 -0500
Received: by mail-pf1-f169.google.com with SMTP id p26so12778831pfq.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:52:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=HYTSQHB1MVvyHktMAtokMZzYXJ3nWbxMB/teC8q2zvtqwnFSZhWi10/QntQiXk3zGn
         i6BmXJ7Cjl1saNmFo7CNfWxVxVvkoh8y3sSwOsdVEgjRzA+7fr/UUM1gf81sPR8rVXm0
         vIKLf1yRyxx73CMPszmrKsdfhEuN/GoUKYSRDVkSX40+wQX/JVqCv1gNwhG7dwkfcVZ+
         aDaJUnPAFLzKgWQ7ikr4q7cPi9B1Kh3KXY9QYQhjdWRvL7bgtAq/FYhQJNvt072UXrmd
         mnbVZIaK8pBrFHYCaYp6H+ILlP0g0S+S+QBa++yJiiBsjs3aPnefI5uhPhoIXMVcdZJr
         1XjQ==
X-Gm-Message-State: APjAAAXe+xOUstUS0WhRyMhCtGaPQ9P0j3Zsf6r0VLPII194v8egAXCg
        LuOr/gBVGxktZYxAcH28KF4OLsxq
X-Google-Smtp-Source: APXvYqw2nCNhTOZmYiL2xdKVDpTgRVc30Nr0bbHsfN44Gnd5McWssFYqdaaU7jHi2vTIy6gEEO7M1g==
X-Received: by 2002:a62:584:: with SMTP id 126mr20970821pff.7.1572889932544;
        Mon, 04 Nov 2019 09:52:12 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p9sm17921123pfq.40.2019.11.04.09.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:52:11 -0800 (PST)
Subject: Re: [PATCH 39/52] stex: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-40-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <76380773-bade-9e3a-5aec-1dd9a87ee730@acm.org>
Date:   Mon, 4 Nov 2019 09:52:10 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-40-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use scsi_build_sense() to format the sense code.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

