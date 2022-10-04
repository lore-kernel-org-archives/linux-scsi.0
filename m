Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38E1BC433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:32:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbiJDWcK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229763AbiJDWcJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:32:09 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5D356DAE6
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:32:08 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id q7so6745322pfl.9
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:32:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=NQnAmmz1j1kCpQJ2Md+DCctnqJz0WLbUaZcpqhtrrRA=;
        b=ZnCZVw5KmTgadWz+e1vq6tPoIpYK/4CJvUffwtM10eaJEQpF3B6fEQdaHD1WmfKHLo
         Dvc9A2lmlnmPLEVRNaj3wsa53ZxP+robcqsRC89hz/iv6EGpkFqADwiODXJX9vQ0GCDC
         criCdWqTBOA7v3mKUX8Q0v2LjgT8f1rZ86VMq5Nm5oC3fQilaYQVRGg3+sxSVmt0Ik6C
         Q9TuIPOCsnn6SsO7QNjz/j0/Bbsy6MIZcDhL8QDNhICB3K85kkaZ0TZYGsRwUhtn8DAY
         /89YUBPaLWTBMHZsDZME/HmT6UgfYN7R1pJFxxVY7+a+Ux7T3nx5/urMUwyeH4nX3O66
         zVxQ==
X-Gm-Message-State: ACrzQf3qkZe9baC7yuTS7r9y8vmEYz4DQxk64G7U8c3jn+SIKKDMg4bC
        AV1syHbYbTekNsODNoka1Xg=
X-Google-Smtp-Source: AMsMyM4IG2PfVRZ60n7gfwCgCg43Ug0deETqq7oJja93c1Hj5a5t/abIf9Mr0gILY2p75GaUZJDofg==
X-Received: by 2002:a63:1508:0:b0:438:eb90:52d1 with SMTP id v8-20020a631508000000b00438eb9052d1mr25475237pgl.252.1664922728245;
        Tue, 04 Oct 2022 15:32:08 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id u2-20020a170902e5c200b001767f6f04efsm9439190plf.242.2022.10.04.15.32.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:32:07 -0700 (PDT)
Message-ID: <571898e1-94af-1e1a-b68e-ae33de987902@acm.org>
Date:   Tue, 4 Oct 2022 15:32:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 07/35] scsi: ch: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-8-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-8-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

