Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3716C4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:18:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2AFF60F91
	for <linux-scsi@archiver.kernel.org>; Sat, 14 Aug 2021 03:18:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236876AbhHNDTG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Aug 2021 23:19:06 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:36401 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236856AbhHNDTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Aug 2021 23:19:05 -0400
Received: by mail-pl1-f179.google.com with SMTP id f3so14453716plg.3;
        Fri, 13 Aug 2021 20:18:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gw8qI1Tpn+0zxsNjkqWp74BTgWz9e49ymx7vSHaQ/N4=;
        b=UIHI8/FpUOV084EtdBPb1RyTyNfOylUzr3Rh2O8oAybCLqqke4gRBHLrUroYGEOoss
         oFT1UdMsnE8ZkRnCZBKIP3id7Rno0gJqwH5CRmC1Cay7puTE7JPGpq02T7RQ+hRA2vk9
         lL54zvHxYAozuwjIb6QzK1Rk/4qd/CEhmQB/5ynOtZym8Zt6Et+NwukCS9H9zgA0/gE3
         1pg699L0tWtvOovFeXgJ6uM69FNXKza1fhf1SA2YzMy0BeBYAVL6UL80zcbQD2MpwrB1
         KTgmaJRqSFeAPcF98LuhCXQn1x+PDJYebc+HR+FHvT94DsPlASTSf3tOTNAA1QWXpkxJ
         YYSw==
X-Gm-Message-State: AOAM53181ospBlOajXR/ConweHa7mmXSjTIlBq17g7FEFFfujtsHvM/f
        i3wy2kE2j5p7D2/y9LBGunc=
X-Google-Smtp-Source: ABdhPJyyn+/5Lgy1wYgnF2GftWu+KnfHCS2A6sysq+CVLX5UuM2uunTlrBxTIgiBU5cKso1liOoJJw==
X-Received: by 2002:a63:36cb:: with SMTP id d194mr5085068pga.224.1628911103099;
        Fri, 13 Aug 2021 20:18:23 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:55d6:7aa0:a6ad:d964? ([2601:647:4000:d7:55d6:7aa0:a6ad:d964])
        by smtp.gmail.com with ESMTPSA id l18sm3719739pff.24.2021.08.13.20.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Aug 2021 20:18:22 -0700 (PDT)
Subject: Re: [PATCH 3/3] scsi: Remove scsi_cmnd.tag
To:     John Garry <john.garry@huawei.com>, satishkh@cisco.com,
        sebaddel@cisco.com, kartilak@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de, hch@lst.de
References: <1628862553-179450-1-git-send-email-john.garry@huawei.com>
 <1628862553-179450-4-git-send-email-john.garry@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <70b0a7da-49de-6e6e-b66f-d7d93bca165f@acm.org>
Date:   Fri, 13 Aug 2021 20:18:20 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <1628862553-179450-4-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/13/21 6:49 AM, John Garry wrote:
> It is never read, so get rid of it.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
