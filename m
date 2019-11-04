Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42411CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A08920848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:50:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbfKDRuG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:50:06 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:40870 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRuG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:50:06 -0500
Received: by mail-pg1-f195.google.com with SMTP id 15so11809313pgt.7
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:50:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=iNdT90nhlMyXNhVQ+6/9jW1qMBRCXtbd9U9LNCT8s013z7dsyYCN/LHiDWZ80pSpZQ
         DJ7rWMAuec8v588lcZSP4Ks62olZ4UwpBkbEp7SydS/ONrMbddeAV57KQXkcHu/zHrXp
         nV71cznf+E3zk4Nwfi5pO4jbBn0ajaCD/OsfMbyXNC7L9WaAhuMbR1SwOuSVzkMbI6eK
         sybR1lotZmfnHNpowxl6FgczufnFvLIf/5pmDnZGNeNKRNl8/iCNi8BHv/wQIOyQMfur
         yqkZ11lbtpqacAES/R27uS6tghUoeipvHdoxCnQBIe+H1S6XWiq3yT4s8rYlDw00Zuj5
         bXtg==
X-Gm-Message-State: APjAAAX/Eah6oc17x17HWvHt7I5sJDn3k2CQ6jdNZActtUFWujhVpKw9
        DG9qhHnJ6KQZqjBryoJL0vltn8lj
X-Google-Smtp-Source: APXvYqyqHkp7cILH9kAFgaz8tPL8UVzm0HC9pZDTJ79DB1iF9wddbxusTo9qsutILVWg8uAoa5aLcg==
X-Received: by 2002:a63:df4e:: with SMTP id h14mr14268194pgj.23.1572889804963;
        Mon, 04 Nov 2019 09:50:04 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id v2sm18706948pgf.39.2019.11.04.09.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:50:04 -0800 (PST)
Subject: Re: [PATCH 32/52] mvumi: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-33-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <be977199-9063-4367-9359-2a0a12133d96@acm.org>
Date:   Mon, 4 Nov 2019 09:50:03 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-33-hare@suse.de>
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

