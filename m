Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BB2EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbiJDWts (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiJDWtp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:49:45 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC4E12DC2
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:49:43 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 70so14085802pjo.4
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:49:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=yYwtOh5vG4r4D/X8p5yR2gP4bRrKguEdOtXyXDNEqKQ=;
        b=MZgocjXRjaw3J8gQBzzQJxJHGPlMKnsu3ejsJl3StPRhfrtP8wBbHNQLjQJBjnSX2L
         9NIXeVlzdcMtd6tWFdG7qO494Op1ndaEfL2LCRla7AGftXxqOLjrNEHCpn6s3tOP5u/9
         0l1qK5RBVTEMkvJN9Lqo5tL9WJLqH8LLGgnP/PTm6btRdbgrgHz/+Ndg5CNHTY6/wxBk
         22uRfKhn0K1h7h/9o6pHtpwZje42mBC7f9TGRY4eqHb7kKM4STwlEUG2ogSyUgweuDPC
         qTnTlXyd/5E5jsrSHhxFiqduRR64+l3UJEnIlfB4ZGSEz9Ef/RPmO6NJ2qdLHsoxhzzP
         ypfQ==
X-Gm-Message-State: ACrzQf2t3z5rtOJjVZLlNbe7ZAbOEO81vXDc7gH8tYl0ZmLeGM/B8KND
        z5o/NZv0ssl1os2uBcLJYoM=
X-Google-Smtp-Source: AMsMyM5JexGldbAh2mmdlxzdir7lhLIvrkNccSFzyPCDO2QiecLvVy0J42Kyit0q++akwPm1IFUvSg==
X-Received: by 2002:a17:903:1cb:b0:178:4689:8f8b with SMTP id e11-20020a17090301cb00b0017846898f8bmr29788003plh.44.1664923783333;
        Tue, 04 Oct 2022 15:49:43 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id t24-20020a17090a449800b001f8c532b93dsm72745pjg.15.2022.10.04.15.49.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:49:42 -0700 (PDT)
Message-ID: <9b4388cf-f2d4-a483-9961-7b75c9475906@acm.org>
Date:   Tue, 4 Oct 2022 15:49:40 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 18/35] scsi: cxlflash: Convert to scsi_exec_req
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-19-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-19-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:53, Mike Christie wrote:
> scsi_execute* is going to be removed. Convert to scsi_exec_req so
> we pass all args in a scsi_exec_args struct.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
