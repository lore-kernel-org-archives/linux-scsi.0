Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2CFDC433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85F8B6121F
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 15:40:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235402AbhDPPkb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 11:40:31 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:45719 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235239AbhDPPka (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 11:40:30 -0400
Received: by mail-pl1-f172.google.com with SMTP id p16so10224848plf.12
        for <linux-scsi@vger.kernel.org>; Fri, 16 Apr 2021 08:40:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=awTDp4qJ01E90kIPKeu5K+4vkbLtauxnOOPmsiHHj60=;
        b=R8rRTXb4d5ZICnqr0N/9oL8EN3S7SMmOU4h5kJ0FAHpX28OYUkiQbbK8YmrYK1Cgeg
         rf9ULlpBuH4CVdGsjZ5wK8KSfvKgUcLh2knPRqZyBBzCu3SoZYCgAZiYq2lJHAjrC35e
         VeryhUixhcvuauE8DNLOaKpJHp4iz/TsSb3FJ/MvcAzYg8m0CxzFyQ7GdKV1JE2o+Mi7
         7KVkzDdo0G5rJi2UFgoYfDbRpWA6YIE2QJLeccRSjJPAM/XbKtgo+8SuXMaCux0f+/F0
         EebZ8iU9oT6WS7yNeCdI6dkIwdN2WwNDbk7LgDpjFuR/Egg1Tpk55zIO7dX9VXz4BYpj
         3+RQ==
X-Gm-Message-State: AOAM532o3IDLVIOtGLY+lAdL7UFyUZmlwyHlT+4LLWYKYbD5sAEJE8/A
        sQvgw0n81HbtAbal4SdvHfE=
X-Google-Smtp-Source: ABdhPJwIKQbgi3bKPLy9Usvb8QOopbY1s1Dytj0CYnuEeBxyesqUmKMtkpMNaS8/9wVWMpKL+WM6FA==
X-Received: by 2002:a17:902:b942:b029:e4:87be:be8c with SMTP id h2-20020a170902b942b02900e487bebe8cmr9899660pls.81.1618587605144;
        Fri, 16 Apr 2021 08:40:05 -0700 (PDT)
Received: from ?IPv6:2601:647:4000:d7:deb4:c899:3eb6:a154? ([2601:647:4000:d7:deb4:c899:3eb6:a154])
        by smtp.gmail.com with ESMTPSA id w2sm5198930pfb.174.2021.04.16.08.40.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:40:04 -0700 (PDT)
Subject: Re: [PATCH v2 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-2-kashyap.desai@broadcom.com>
 <32dd1ee9-4172-50b9-493c-181ae66da11c@acm.org>
 <39cd58b5a03db494176f2f1df1ef365c@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ce374ec3-754f-e36d-f844-088ac17535b0@acm.org>
Date:   Fri, 16 Apr 2021 08:40:03 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <39cd58b5a03db494176f2f1df1ef365c@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 3:53 AM, Kashyap Desai wrote:
[ ... ]
>>> +#ifndef MPI3_POINTER
>>> +#define MPI3_POINTER    *
>>> +#endif  /* MPI3_POINTER */
>>
>> As far as I know there are no far pointers in the Linux kernel.
> 
> Hi Bart - I can remove the comment and just use below line in this file -
> #define MPI3_POINTER    *
> 
> Common MPI header file which is directly derived from common repository
> within a Broadcom like " mpi30_cnfg.h", " mpi30_transport.h" etc. has
> reference of MPI3_POINTER  instead of directly using "*" there.
> It may be useful for some third party development (like SDK) and they can
> replace MPI3_POINTER  accordingly. Only mpi30_types.h is Linux only file and
> we add wrapper in this file to make sure common header file compiles on
> Linux instead of completely replacing whole MPI header file.

How about changing all MPI3_POINTER occurrences into MPI3_POINTER_ATTR *
and defining MPI3_POINTER_ATTR as an empty macro in this header file?

>>> +typedef u8 U8;
>>> +typedef __le16 U16;
>>
>> Introducing U16 as an alias for __le16 is confusing since there is already
>> an
>> 'u16' type in the Linux kernel. Please use the __le* types directly.
> 
> I explain this issue in above comment.

I'm not sure that explanation is sufficient. Has it been considered to
change all U16 occurrences into __le16 and to add 'typedef uint16_t
__le16;' in the appropriate header file if building for another
operating system than Linux?

>>> +typedef U8 * PU8;
>>> +typedef U16 * PU16;
>>> +typedef U32 * PU32;
>>> +typedef U64 * PU64;
>>
>> Please use __le* directly instead of introducing the above aliases.
>> Please also follow the Linux kernel coding style (no space after '*').
> 
> There is no reference in mpi3mr driver to use above defines. I will remove
> them completely.

Thanks!

Bart.
