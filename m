Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAA44C00145
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 21:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiLLVSt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 16:18:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233513AbiLLVSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 16:18:18 -0500
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 989E6FCF3
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:17:11 -0800 (PST)
Received: by mail-pf1-f173.google.com with SMTP id c13so822780pfp.5
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 13:17:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gtpsspZXl0m1+8kN7kzyraKJsc2A0VuOpQ7u24DDVOc=;
        b=FHE6HBipVnJWTs0VjfNwvYd4IpM4bPi46cZS2eKmw1oipGHKiEFVALVaoYtsY+QejU
         qI8UyQvD4CaBbMkgA/pqLO3ulEwCal+9qxw87ZWkXMw1Ezj+85XVu58BhgLYoGe+IwN3
         URRVQ8R/pvgX+Ss8e37L/vqAnAhzSDuUrsO47zUAthcLuFQ05VGla1ieD52ZpYqKQwim
         7PZ29/Rip9PvcvyAMBIQlMIOwtl06aImqNSzYk78JTAQo2G3hJAENrw21dULroQquqhw
         nXYFUTKd8PaIMZCpeQD3hUfwLLXBViGHO0RlrHRW4LTRmY1wOle12GRvHiQ3dR2DlObI
         Xz9Q==
X-Gm-Message-State: ANoB5plEkVgaUO/m95nJqbzZhgScJYr/GIXTaFRd5bflxYZewe44hxU6
        cBYsO7WLM8qIwdznjWxNB8s=
X-Google-Smtp-Source: AA0mqf5vbgotsCI0MohQVXZqUqhaW9q9nSVwFOvtlzU6/PaH/q0u4S3ASJImPpGFbgtqBrAKx0syVw==
X-Received: by 2002:a62:602:0:b0:572:9681:101e with SMTP id 2-20020a620602000000b005729681101emr15907313pfg.25.1670879830930;
        Mon, 12 Dec 2022 13:17:10 -0800 (PST)
Received: from [10.20.6.139] (rrcs-24-43-192-3.west.biz.rr.com. [24.43.192.3])
        by smtp.gmail.com with ESMTPSA id k30-20020aa7999e000000b00574866d619asm6251421pfh.119.2022.12.12.13.17.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Dec 2022 13:17:10 -0800 (PST)
Message-ID: <ea7e0d66-50af-82d4-df38-0c75782f8082@acm.org>
Date:   Mon, 12 Dec 2022 11:17:08 -1000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 09/15] scsi: zbc: Convert to scsi_execute_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        john.g.garry@oracle.com, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221209061325.705999-1-michael.christie@oracle.com>
 <20221209061325.705999-10-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221209061325.705999-10-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/8/22 22:13, Mike Christie wrote:
> scsi_execute_req is going to be removed. Conver zbc to scsi_execute_cmd.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

