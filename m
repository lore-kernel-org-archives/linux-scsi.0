Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36842CA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:40:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0FE0D20869
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:40:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKDRkk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:40:40 -0500
Received: from mail-pf1-f194.google.com ([209.85.210.194]:37986 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728322AbfKDRkk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:40:40 -0500
Received: by mail-pf1-f194.google.com with SMTP id c13so12733641pfp.5
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:40:40 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+dph0Raqdsf//+GDu2MAr+c+IolWVXOaz7N10yfWb6g=;
        b=kQ/Q43czltiGRLaUvlPjedx0yMfUjz7tWCXepbGVuP4AhvRk7t4FUUZD/A15LOLgtS
         rrG57XXu8DVuP0s2F2excE/BYOn6xK38ZvEpqajHmZt55v3wKCXtH5uImBMChtDZM0WY
         970XNaxJa4uK/9I3DAw+AtNMJPAbQBnS3umb2n/LaeL+T0vzYsifkzUIzZzz6dRY6LjK
         SArLfb5iPMZKFV7MSJfsU8HXMWKAVRzEwfLEFPZzBwRT7UWMz8Nt+JcYOaQE7Talr3Tt
         8SS5WOk0irQ8PAdydweHnVHJd6/tgpZP5fULayv8ZU2JJ6fRnPwJKouoGDAMg8ZEbvd2
         ADDA==
X-Gm-Message-State: APjAAAVeBSrtpcZPYeVFeOUYgLlCjzM7bRWajYeXaaAXyJCgWSpSCs2Y
        rS1wzKYGxt0SrQMjQV20HRc8pFxM
X-Google-Smtp-Source: APXvYqzKcnVd8HiDJ+BdFFv74afWR9Rj8EcnxHCcaLaBSwuzFtGoCodhKtpNTPCRJtiHMfKhprkfYg==
X-Received: by 2002:a17:90a:fa02:: with SMTP id cm2mr353368pjb.129.1572889239478;
        Mon, 04 Nov 2019 09:40:39 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j12sm15161418pfe.32.2019.11.04.09.40.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:40:38 -0800 (PST)
Subject: Re: [PATCH 13/52] dpt_i2o: use standard SAM status codes
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-14-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <6fb1c477-8743-16dc-a3ad-1e6b012104b5@acm.org>
Date:   Mon, 4 Nov 2019 09:40:37 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-14-hare@suse.de>
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
