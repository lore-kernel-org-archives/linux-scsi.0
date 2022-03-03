Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BC6BC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Mar 2022 00:42:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiCCAnV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Mar 2022 19:43:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230481AbiCCAnU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Mar 2022 19:43:20 -0500
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6B6201AF
        for <linux-scsi@vger.kernel.org>; Wed,  2 Mar 2022 16:42:36 -0800 (PST)
Received: by mail-pl1-f174.google.com with SMTP id h17so3075311plc.5
        for <linux-scsi@vger.kernel.org>; Wed, 02 Mar 2022 16:42:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QTa5WbW7Xf1ghJwsko2/bZ7lNSN0/3eJEf0L6cmwB2s=;
        b=m6Cs+MHMN2G2NRz7fQXH9fcHK42dlELT/copIfT7ICeT2m3x6mv67hTD5uuOW8xQ2v
         mgGiuXQZSQIAqxituh128ac9VQo5xqga0EUnJNZ43KbmRFkEwvekZyipVPDOvZIYYQmu
         18rtu+MA6aGZJadAanVweKspbXXuRtV+aLgHv2KvghAd8Vh7MveiR9xC10bWLXan8BHL
         FhB+lEQs0UTE4lz2qcBH0trJJJzkk+ioKFLWDQgBRTrZ8q5/vUd5+y0p8paBFCggYUpB
         Pdj77PrYd/xsmXhmoTIApYYLQDVTyt7XZ9kTRH1Qyj8F+UumkDG2wgKn8DWvGpY33GSn
         OrDA==
X-Gm-Message-State: AOAM530t85aNB+xdysTUUjfhjqGSH2fHMOEssI7L7S4f1l3CJgqUepGN
        XfUwxn1JKiqKjysEOX201439w6u3l5M=
X-Google-Smtp-Source: ABdhPJwOSS8OPI0SEZxut0MwQ+MeqaUd7MsBgeFh2iMwtyp94vghkugnQa9duvIJDDQlDcB5IYj4JQ==
X-Received: by 2002:a17:902:7e4f:b0:14f:dc56:95c9 with SMTP id a15-20020a1709027e4f00b0014fdc5695c9mr34320963pln.9.1646268156043;
        Wed, 02 Mar 2022 16:42:36 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id v21-20020a056a00149500b004e15a113300sm351464pfu.198.2022.03.02.16.42.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Mar 2022 16:42:35 -0800 (PST)
Message-ID: <cc97ac68-c425-2591-74b8-bfece128af16@acm.org>
Date:   Wed, 2 Mar 2022 16:42:34 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 07/14] scsi: sd: Switch to using scsi_device VPD pages
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-8-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220302053559.32147-8-martin.petersen@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 21:35, Martin K. Petersen wrote:
> Use the VPD pages already provided by the SCSI midlayer. No need to
> request them individually in the SCSI disk driver.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
