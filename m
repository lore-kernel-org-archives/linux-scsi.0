Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 754FAEB64DC
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 14:58:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbjGUO6b (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 10:58:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229973AbjGUO6a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 10:58:30 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 210122128
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 07:58:30 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-666eba6f3d6so1355195b3a.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 07:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689951509; x=1690556309;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pkXbqMNG/3xWGrGWK+tgXzEC8BYRhi/Q3UTuAsiBd7o=;
        b=e7oIuchS+JBDFEK44413JzNUElz3IkAuD5iJxbwDXAjnjxwsoW98c3ScKHKUQsRcdT
         7IlhXpSwDjoWSmdoSlpAqN76SfrxW7Tiict27eOMN0pIeDsezYd9zWqj7DkTK4YKjs+Y
         gnTkHD+6L4OQ6/2G+tzY8qv+hfr5t2fBos79xTy6uE9/rHNe1GFvwb3+NtQcOUSzxn9p
         vdblXpLSHxhIEiy50aGCdw+cqEdh3oqFVaYglgjl8Om9EfXvjDzJjiEjDN3nJWUM0A8I
         LNoSfGTbXB5SXN5aPR6edYbP7BDbLq0dMlu8lmn1rk0HM052XYHg1BH7wZPOzU5awl6E
         1OyQ==
X-Gm-Message-State: ABy/qLY3AOErRaUzVJEo5XhxgdrletGvcy3m4ZAVqD+44Gy0Qo/F359U
        Nh3bqjmaD0ljza0KCj9+Zt8=
X-Google-Smtp-Source: APBJJlGOVAO9CNljhKLDsA+Jixc/NQtUL+biyIOHt9IZneHWkIiFulCpXTg0HL2qWVmZpHxf42ZRGw==
X-Received: by 2002:a05:6a00:248d:b0:657:f26e:b01a with SMTP id c13-20020a056a00248d00b00657f26eb01amr346156pfv.26.1689951509404;
        Fri, 21 Jul 2023 07:58:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:5043:9124:70cb:43f9? ([2620:15c:211:201:5043:9124:70cb:43f9])
        by smtp.gmail.com with ESMTPSA id t14-20020aa7938e000000b00682b299b6besm3119731pfe.70.2023.07.21.07.58.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 07:58:29 -0700 (PDT)
Message-ID: <642a49ed-4920-9c74-40aa-81d5c859ce79@acm.org>
Date:   Fri, 21 Jul 2023 07:58:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH] bnx2fc: Remove dma_alloc_coherent to suppress the BUG_ON.
Content-Language: en-US
To:     Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        Jerry Snitselar <jsnitsel@redhat.com>
References: <20230721102320.9559-1-skashyap@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230721102320.9559-1-skashyap@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/21/23 03:23, Saurav Kashyap wrote:
> From: Jerry Snitselar <jsnitsel@redhat.com>
> [ ... ]
> Signed-off-by: Jerry Snitselar <jsnitsel@redhat.com>

Has Jerry's name changed or has his name been misspelled? I think
a letter 'a' is missing from his name.

Bart.

