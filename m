Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1A0AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Jul 2022 18:12:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239863AbiGSSMl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Jul 2022 14:12:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232034AbiGSSMk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jul 2022 14:12:40 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAEBC54058
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 11:12:39 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 72so14238390pge.0
        for <linux-scsi@vger.kernel.org>; Tue, 19 Jul 2022 11:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=672a9okLTN1No73092Aovvbe+yHByzeh/y6E3iqLsOQ=;
        b=GZTddLRT32nHAVqmK08ca2KolSPXpyTCgneZNOCjJTjdrvPoj4kU1DpUuId/hW+RSB
         925MrWjv2aBLFZlbkQ6Sgi6iC7BTVgrCMhg9aigfel9SR7/2U6kQQaS/XWqnojZ73pNR
         kl347aYaMmLoy8QZEi7DCwDd+PmMRjmMvZZyycdIU+4IOk4a9wy+gBLgP3mR9p6T6UiA
         ozqtPbaQjsXo//IsH1dSQgQtpeGju56lBH80rFEcWAsZgvmCBmGBbfMGD5mGg/8RulEN
         3mK3pIv3wVYlj4lJgpQR6ISP2JS2/pUSE+wWNk46mcNWidKZkCrKBEpWKVR/QfC39vxl
         umdw==
X-Gm-Message-State: AJIora8uu1eWdmcwOY5UBEZ6gn8xbipEl8Mpb9TLb14KaVzl49mtHxHY
        OoT8J9m0je+Zip2pHj2w8zg=
X-Google-Smtp-Source: AGRyM1t4L8HXR1+uoygKRwyQAb/rJMHxGC/Ui+CsUSCHsKgsaC6GMidPlbXtlkYRmSwUGWO+j1KloA==
X-Received: by 2002:a63:686:0:b0:414:1a88:3b98 with SMTP id 128-20020a630686000000b004141a883b98mr30213050pgg.106.1658254359188;
        Tue, 19 Jul 2022 11:12:39 -0700 (PDT)
Received: from ?IPV6:2600:1010:b002:e126:5611:6026:69c2:37bc? ([2600:1010:b002:e126:5611:6026:69c2:37bc])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7842a000000b0050dc762816asm11742292pfn.68.2022.07.19.11.12.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Jul 2022 11:12:38 -0700 (PDT)
Message-ID: <554f38b5-8506-2ab3-dbff-bcc18b00000f@acm.org>
Date:   Tue, 19 Jul 2022 11:12:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] ufs: host: ufschd-pltfrm: Hold reference returned by
 of_parse_phandle()
Content-Language: en-US
To:     Liang He <windhl@126.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
References: <20220715001703.389981-1-windhl@126.com>
 <0209504a-fdd5-5987-4772-dfb14c6ceafc@acm.org>
 <741595c3.743.1820a1c502e.Coremail.windhl@126.com>
 <6e005dc0-720e-41b1-10df-cc088245bccb@acm.org>
 <23e4cd6a.1fef.18214599628.Coremail.windhl@126.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <23e4cd6a.1fef.18214599628.Coremail.windhl@126.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/18/22 19:46, Liang He wrote:
> Can you help me as I have a trouble about the indentation.
> 
> When I align descendants to a function open parenthesis in VIM editor,
> but when I generate the patch, I find the second line always missing one space in
> patch format. So is there any problem if I send this patch?
> 
> I make sure that the alignment in VIM is OK.

Hi Liang,

Please don't worry about this. When a code change is converted into a 
patch, a single character is inserted at the start of each line (plus, 
minus or space). That makes code that is indented with tabs look weird. 
This is normal.

Bart.

