Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0049DC433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Oct 2022 22:30:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230418AbiJDWac (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Oct 2022 18:30:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbiJDWaa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Oct 2022 18:30:30 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610EE69192
        for <linux-scsi@vger.kernel.org>; Tue,  4 Oct 2022 15:30:30 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id z20so7342795plb.10
        for <linux-scsi@vger.kernel.org>; Tue, 04 Oct 2022 15:30:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=5O1jUXPfdSDAsq1KAyh/n4UJTCC3+g7cwW7Aun553eI=;
        b=0qmpswA2LG1o8grPqDW5qbmZMkcnyV+Z0PWzSwaSzIVeyCggwygC+omkvMRrd1AhPQ
         Ik2riTHMi0rSVVXbh9XS2foAOaCgMbMx+Czo5ybeHeXC5ND8qJ034e0CfUsrz81Mc2Y0
         qD0IRiwzgJ0xqaFkBqRg9sj/PiEL9JGZ04OBV1cLbAhn42jfw07jZv8dvqjZ/QqKUDB/
         lycIE3lUPTnQQQxq9qXk2c0bSUvwhRLMnXxIouXcOXKi3oTD86+AnGXODT39F1nwxFfV
         j9S8ZMPVAB09p+7EnpmOIJcAyval8AGXrc1SWsk9dYdN0NetNMGwT0cM+cjBh5eGEj2D
         krxw==
X-Gm-Message-State: ACrzQf1IrrlIZtDN2pFIUIx/h9cNR/o37bUh80Hblruco9MSedPNy3mv
        /gvSV3MZ6nP9lEjVyGfFDvBuE222BIE=
X-Google-Smtp-Source: AMsMyM7YO6m6gT38tOEMxkrO1TgVigCEL90+q9SRa76SLfp5bIEYncIErrxDFvo8Tp9ShYecOO/STA==
X-Received: by 2002:a17:902:8bc5:b0:17f:79f2:21e8 with SMTP id r5-20020a1709028bc500b0017f79f221e8mr3256529plo.63.1664922629691;
        Tue, 04 Oct 2022 15:30:29 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b6b5:f763:ff03:8283? ([2620:15c:211:201:b6b5:f763:ff03:8283])
        by smtp.gmail.com with ESMTPSA id j17-20020a635511000000b00439c6a4e1ccsm8792666pgb.62.2022.10.04.15.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Oct 2022 15:30:28 -0700 (PDT)
Message-ID: <db257fef-b73c-4d16-6554-cd521af544ad@acm.org>
Date:   Tue, 4 Oct 2022 15:30:26 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH v3 04/35] scsi: Add scsi_failure field to scsi_exec_args
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20221003175321.8040-1-michael.christie@oracle.com>
 <20221003175321.8040-5-michael.christie@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20221003175321.8040-5-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/3/22 10:52, Mike Christie wrote:
> Allow SCSI execution callers to pass in a list of failures they want
> retried.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
