Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BC5C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 18:16:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0F0E224F4
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 18:16:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727988AbgLVSQI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 13:16:08 -0500
Received: from mail-pl1-f173.google.com ([209.85.214.173]:35062 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727094AbgLVSQH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 13:16:07 -0500
Received: by mail-pl1-f173.google.com with SMTP id g3so7843728plp.2
        for <linux-scsi@vger.kernel.org>; Tue, 22 Dec 2020 10:15:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=REyEQabJNHHO2Qk6g2HEBmyiWDdDVQSMXyx+WFX6tzA=;
        b=npvjF6gsgQ7RAGsntjcZCTB1TngH3Htae2DpcxhF29ZO23jQbqI5vRf9KDyL5EJ3Qd
         RK6oc3RS22geGv0zQX8DGkQqH7AdhpYIK95oqwnda9ql/0sLqDCR/YG1mUBCjNWFNgJI
         fldjhAiCEeD2LhypraehMIFE9B9g3S+noDHmMWzkP98llTkDVehK1XPH/bjVlSEaS+aE
         M0zUHjT/n9t9Ul0XOv2wigDYakzyVtoeXDulZDeWIjeSi/a8GhsuZ5tkLWG5uPW14LoK
         /JZfMvYSOpUrKCQhpPUg3X7QYahNmBr21xGuVpIrpf987v65PEoeSi+huGTzYfAB38kK
         Kfog==
X-Gm-Message-State: AOAM531ys+zBEfCp5GQG6DheyT0qeIGC7Osqv3fbjBLQ7rXwPW4YkWfB
        Awtkao4XnZSPnn+ANEjLOMs=
X-Google-Smtp-Source: ABdhPJyen6unsUBjUdUJDeyNppIZC/eCIARIg3QQVoXIeQ4JPsou3POn8D1jRg+tHMt4/26wKcQkBw==
X-Received: by 2002:a17:902:7e85:b029:da:726a:3a4f with SMTP id z5-20020a1709027e85b02900da726a3a4fmr1200880pla.65.1608660926936;
        Tue, 22 Dec 2020 10:15:26 -0800 (PST)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id i7sm21349139pfc.50.2020.12.22.10.15.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Dec 2020 10:15:25 -0800 (PST)
Subject: Re: [PATCH 01/24] mpi3mr: add mpi30 Rev-R headers and Kconfig
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-2-kashyap.desai@broadcom.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <514fce24-b522-463d-4ebf-2a68afcc3bb4@acm.org>
Date:   Tue, 22 Dec 2020 10:15:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-2-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 2:11 AM, Kashyap Desai wrote:
> diff --git a/drivers/scsi/mpi3mr/mpi/mpi30_type.h b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
> new file mode 100644
> index 000000000000..5de35e7a660f
> --- /dev/null
> +++ b/drivers/scsi/mpi3mr/mpi/mpi30_type.h
> @@ -0,0 +1,89 @@
> +/* SPDX-License-Identifier: GPL-2.0-or-later */
> +/*
> + *  Copyright 2016-2020 Broadcom Inc. All rights reserved.
> + *
> + *           Name: mpi30_type.h
> + *    Description: MPI basic type definitions
> + *  Creation Date: 10/07/2016
> + *        Version: 03.00.00
> + */
> +#ifndef MPI30_TYPE_H
> +#define MPI30_TYPE_H     1
> +
> +/*****************************************************************************
> + * Define MPI3_POINTER if it has not already been defined. By default        *
> + * MPI3_POINTER is defined to be a near pointer. MPI3_POINTER can be defined *
> + * as a far pointer by defining MPI3_POINTER as "far *" before this header   *
> + * file is included.                                                         *
> + ****************************************************************************/
> +#ifndef MPI3_POINTER
> +#define MPI3_POINTER    *
> +#endif  /* MPI3_POINTER */

Near and far pointers are concepts that come from 16-bit Intel
architectures. I think that these concepts are not relevant in the Linux
kernel. Hence please remove the MPI3_POINTER macro and use '*' directly.

> +typedef u8 U8;
> +typedef __le16 U16;
> +typedef __le32 U32;
> +typedef __le64 U64 __aligned(4);

Typedefs like the above reduce source code readability significantly.
Please remove these typedefs and use __le16 etc. directly.

> +typedef U8 * PU8;
> +typedef U16 * PU16;
> +typedef U32 * PU32;
> +typedef U64 * PU64;

Same comment for the above typedefs.

> +typedef struct _S64struct {
> +    U32         Low;
> +    S32         High;
> +} S64struct;
> +
> +typedef struct _U64struct {
> +    U32         Low;
> +    U32         High;
> +} U64struct;

Please use upper_32_bits() and lower_32_bits() and remove the above
structure definitions.

> +typedef S8 * PS8;
> +typedef U8 * PU8;
> +typedef S16 * PS16;
> +typedef U16 * PU16;
> +typedef S32         *PS32;
> +typedef U32         *PU32;
> +typedef S64 * PS64;
> +typedef U64 * PU64;
> +typedef S64struct * PS64struct;
> +typedef U64struct * PU64struct;

Please remove these typedefs too. Additionally, please follow the Linux
kernel coding style (only a space at the left of '*' but not at the right).

Thanks,

Bart.
