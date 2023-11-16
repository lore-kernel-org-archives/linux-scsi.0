Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE712C072A2
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 02:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344622AbjKPCeD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 21:34:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344517AbjKPCeD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 21:34:03 -0500
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73BA4D48;
        Wed, 15 Nov 2023 18:33:55 -0800 (PST)
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1cc394f4cdfso3280265ad.0;
        Wed, 15 Nov 2023 18:33:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700102035; x=1700706835;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bzOlheFwXArRNlERVd0wsnja017eUXH4i4Jl4/RUJVM=;
        b=GGRP1iZ45aRDymg0S+yiwDd6s6uVf7CNCvGDMR7stzL4KEfd+1EzV06mm8NkMvq5s7
         CNld1Z1noOwokVWT5W+f/2SfuippOcelo+O5K2YMQMjDTogNP5UeQohjdSjMIv5x2dYX
         fdL6rjMZbmZZTN7O8h498BQYmN33yJbYYL6jJoWK5vkZ4GNZwunqsdwvKNZTKciruyXq
         S72CbTJ9XUlacbiV7OOSNoSxVlhPI1CJ/dQDmgD+j7eZrguz7GYhersXSJfUyl3kknnu
         pbGOmRShTpaW25PNgv20CYOb7rBo2juDDCdclOH3HwbPW4sm0EHex1BcBbCJ/JbI7IMM
         KW3w==
X-Gm-Message-State: AOJu0YxVVS8xS7M9I56ZAYcVbdXy7JwevTBpkpfR0lOevjgYSOD5nSa7
        KrMMUDk+BMytHjRDQiIwKqU=
X-Google-Smtp-Source: AGHT+IHdl+3RcU9uX6yfyZH8PL/1dGRSa25bKqxBsJcrIvGzeRu4clD8brbfWCIVYnI1wvWs6QPECQ==
X-Received: by 2002:a17:902:bf02:b0:1cc:29ef:df81 with SMTP id bi2-20020a170902bf0200b001cc29efdf81mr6738724plb.41.1700102034770;
        Wed, 15 Nov 2023 18:33:54 -0800 (PST)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net. [73.231.117.72])
        by smtp.gmail.com with ESMTPSA id a2-20020a170902ee8200b001c737950e4dsm8109504pld.2.2023.11.15.18.33.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Nov 2023 18:33:54 -0800 (PST)
Message-ID: <663b4db6-6c8d-4948-80d0-a7bbf75a33b4@acm.org>
Date:   Wed, 15 Nov 2023 18:33:51 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: mediatek: Fix the maintainer for MediaTek UFS
 hooks
Content-Language: en-US
To:     Stanley Jhu <chu.stanley@gmail.com>, inux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, peter.wang@gmail.com
Cc:     matthias.bgg@gmail.com, angelogioacchino.delregno@collabora.com
References: <20231116020254.10590-1-chu.stanley@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20231116020254.10590-1-chu.stanley@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/15/23 18:02, Stanley Jhu wrote:
> Fix the maintainer for MediaTek UFS hooks since the origianl
> email address is not available anymore.

Why is the original email address no longer valid?

How to verify that the old and the new email address are associated
with the same person?

Thanks,

Bart.

