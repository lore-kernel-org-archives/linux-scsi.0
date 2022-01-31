Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70C64C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 17:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243610AbiAaRWz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 12:22:55 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:34759 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243562AbiAaRWz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 12:22:55 -0500
Received: by mail-pf1-f175.google.com with SMTP id v74so13458719pfc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 09:22:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=frkcfjFNhS4h3qvSohvP3h7OquYNhzS0IordgVqcTNo=;
        b=tQ6s0IOQ/wGbwa2pmiDIJfDiP4NJijlfYn7QpclRGzFA5VwOs4gudtjM3zCoXOVynF
         CQ49ETgY0C2P5ORMwFzZwDIH6ol3VxnR0vQ9378SJQ0PsIvwcOwsp3AvrkCdy1PYeoS1
         F/yTnyrH9Ury1m/bdT7AxUtkmLYE9nUXQ4vytujUobyRQMEEpjSTTsQA3fYAZD42JxFA
         mut+KrrXErDxVFIkQaguJTUDYBn15MfPInt8/fzBFG0K6m9LmEtpCsfcynwMDJr73cG+
         PKIu8MLujmk5b46d8SmBNO+giWJC6QK7q3pF5xZUNtWY4PWRVYQ3so91LvuWcLlf2PtA
         IPpQ==
X-Gm-Message-State: AOAM530WGWIP1aYn0U9qeiAJzibTxsd4SHVSd/tUfxFPawlh3MCFZdyI
        Yr/XTGdZeTMBlzzH1y6czak=
X-Google-Smtp-Source: ABdhPJzeZqGRr/5zUWCTe8kHmj8FBqXTibtz3fwHEXQ5Rjhmxau3DGwNJA7EJbV6OeTI1Ff/I61yDQ==
X-Received: by 2002:a63:f942:: with SMTP id q2mr17671882pgk.573.1643649774707;
        Mon, 31 Jan 2022 09:22:54 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id nl12sm13072435pjb.1.2022.01.31.09.22.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Jan 2022 09:22:54 -0800 (PST)
Message-ID: <0e0742e4-e250-986e-faf1-bda86ea313ce@acm.org>
Date:   Mon, 31 Jan 2022 09:22:52 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 25/44] mac53c94: Fix a set-but-not-used compiler warning
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "benh@kernel.crashing.org" <benh@kernel.crashing.org>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-26-bvanassche@acm.org>
 <95095a97c5d9015cd259afcbf6e01ee52c839d4e.camel@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <95095a97c5d9015cd259afcbf6e01ee52c839d4e.camel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/31/22 03:21, Johannes Thumshirn wrote:
> On Fri, 2022-01-28 at 14:18 -0800, Bart Van Assche wrote:
>> +       readb(&regs->interrupt);
> 
> Again
> 
> 	(void)readb(&regs->interrupt);

I will make that change.

Thanks,

Bart.
