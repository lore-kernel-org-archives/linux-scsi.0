Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59FB3CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:39:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3716120869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:39:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728957AbfKDRjf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:39:35 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41894 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728012AbfKDRjf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:39:35 -0500
Received: by mail-pf1-f194.google.com with SMTP id p26so12728646pfq.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:39:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=idaSPZoH0up3cK+8UHALu5ivqDZeG71zWqYStIKxm2f9tXGNknjHamictdvfBo/Gjx
         5sBi/nGVzwJScAAAIt9P0HBItmuFCDs2n7G8QZdxiygu13dU2zWQiLbRCP2bSn94GO+S
         ZLZ3ajlGi2+g11Q/lnotRHN4D+Hag4rBImuY8VUSfkqU2OP+ppiWshMQaWZ1afbRnWnW
         PwPFsvmpOQNSpL3vyXZ2/JPNGO7u7MOMOauW3A2FNfybVLxbqyCZnwQxVENiCe4NWQJ7
         knmVX+5vTw57SiUgcJLnON2MMsBbt6CPQFsk1Eml39IIjt6nn/qElClJAjJr9N6xFdkU
         ed2w==
X-Gm-Message-State: APjAAAVC1Z5u1W0g0dzP2MoucDoaSeS5Rwsy9VezO0Y8Nyeps/bADS/d
        +nZH1RmzPLbCGLrEsBua1i7l3jpm
X-Google-Smtp-Source: APXvYqzWqu+7QsIVtetVebbPWm1Z2i3stJDsymiWx/BauZGm1CnxRLrixQLn+DoHceDxHNV0lmfzVA==
X-Received: by 2002:a62:b419:: with SMTP id h25mr545714pfn.52.1572889174550;
        Mon, 04 Nov 2019 09:39:34 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id l72sm24441702pjb.18.2019.11.04.09.39.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:39:33 -0800 (PST)
Subject: Re: [PATCH 11/52] megaraid_mboxi: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-12-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <abcd6f4a-26d0-afb6-7565-4d6c8a874190@acm.org>
Date:   Mon, 4 Nov 2019 09:39:32 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-12-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Use standard SAM status codes and omit the explicit shift to convert
> from linux-specific ones.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
