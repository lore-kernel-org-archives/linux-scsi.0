Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37B5CCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 109E220848
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729305AbfKDRtd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:49:33 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:46585 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbfKDRtd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:49:33 -0500
Received: by mail-pg1-f194.google.com with SMTP id f19so11786583pgn.13
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:49:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=W4M48syZy3IOG6k9Wnu8Z92P0trNI+sdDvtZ8y97oLE=;
        b=Quwk/muuTS3AYMGioLTvJkJ5figLqW2rVLge9W0M+spEAmIqi2yJB3Lil315MyQWxS
         qpvEXVex21k3UHBVwqRYZOksfvdrPV/8H5eHdBY8KnUm6XLYprqsNzjJRz3LvijJNQwp
         mbVLtBY1PY0XzvW0jKdOeBNlZc0m2DiaHDE7TpnWYxlT+3EyCkH5v0GqrHjYXSXR4g1L
         pHFaGFvr2BcjcLr2/ryRWUre/hRlQPoQ1SVryXkXU+ag/YG19yufIHsNDLimuDy91r06
         /XefxedrGvkYVCLVpMD0HMugN2G+1P7jdDdqjDFADIe2Hlj6qJUN26DUlrbQ2dY7kaPW
         Jkzg==
X-Gm-Message-State: APjAAAXeUzxgXSdyhJmuE/WiN60np7JAcP9baqwAIpXS7BlDVS0XiqzF
        jAqj+5vMuPaAW/ALw6oM0s186lUh
X-Google-Smtp-Source: APXvYqxrlcGBgiQTmByEh6O7F2RgQj7/ZGt44kZkeav9RyD6UrzN+mIW4T+HedGOhw6hE3EgLZFDGw==
X-Received: by 2002:a62:7796:: with SMTP id s144mr11629020pfc.37.1572889772475;
        Mon, 04 Nov 2019 09:49:32 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f2sm14084021pfg.48.2019.11.04.09.49.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:49:31 -0800 (PST)
Subject: Re: [PATCH 29/52] libiscsi: use scsi_build_sense()
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-30-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ccaa7904-6097-f499-b0e2-61a83331afa1@acm.org>
Date:   Mon, 4 Nov 2019 09:49:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-30-hare@suse.de>
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

