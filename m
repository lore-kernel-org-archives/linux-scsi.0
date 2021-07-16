Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B53D5C636CA
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 21:27:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882FF613EB
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Jul 2021 21:27:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235125AbhGPVay (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Jul 2021 17:30:54 -0400
Received: from mail-pg1-f182.google.com ([209.85.215.182]:38504 "EHLO
        mail-pg1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235209AbhGPVax (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Jul 2021 17:30:53 -0400
Received: by mail-pg1-f182.google.com with SMTP id h4so11214522pgp.5
        for <linux-scsi@vger.kernel.org>; Fri, 16 Jul 2021 14:27:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3odZj/uCyXmVBdX374XlfibOd+yl8Fb7o7RCtjQfCEA=;
        b=bbs7QQovggiO7qDanlrNA/ageePHq/N/lQPx/p4yrMtx0dWvZXmU6kGcF0aV+oMGOX
         hA8RArMi7OCf2ZEqbP5ySQHfdMNLN274GRn7E7bHxc7SaerGMkRoau+LEIj2qpjLTaBC
         z7fhRj/tga5+o5E/FUwaY7Inek3xvGvgevCHeNF84RteLEgo56KQ5qmKOnzOQ3RJNpJv
         riCvHgopdBjU6gUOXLdRChwhuZeKegdXtk+C20dx+4Ss/rpHlSbKMfYnVZvixtWWM1Q+
         TZfL0jZ8du4KbVIzfS+OsP1Qy1cGQDKeOn+HuF/KPuQ4iAbm+1D296sV5y+TeNerpX1b
         mLtA==
X-Gm-Message-State: AOAM532FWcFPkrJ9iY0kPk1iCIEpFYLkqmdNwCovCUyt63Bqnvo66HU4
        +aRdOVSNN54qCfuEcow7M9L7X0z0dXs=
X-Google-Smtp-Source: ABdhPJyW1Tz1RBi48aUVSQOg0dBiMEA5hsHkGIUyx6qAaRitPObWykcaQy56fuSn3X85uMROZzFLFw==
X-Received: by 2002:a63:48f:: with SMTP id 137mr11939723pge.257.1626470877117;
        Fri, 16 Jul 2021 14:27:57 -0700 (PDT)
Received: from ?IPv6:2620:0:1000:2004:ad12:9dbc:6e29:6c02? ([2620:0:1000:2004:ad12:9dbc:6e29:6c02])
        by smtp.gmail.com with ESMTPSA id n3sm11534133pfn.216.2021.07.16.14.27.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Jul 2021 14:27:56 -0700 (PDT)
Subject: Re: [PATCH 00/15] Subject: Protection information and block size
 cleanup
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20210609033929.3815-1-martin.petersen@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c1c075c5-5b2d-afbe-95ee-c5c02ecba1a0@acm.org>
Date:   Fri, 16 Jul 2021 14:27:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210609033929.3815-1-martin.petersen@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 8:39 PM, Martin K. Petersen wrote:
> This series cleans up how low-level device drivers go about handling
> protection information. The SCSI midlayer provides a set of flags and
> helpers but not all drivers currently use them. This series updates
> the drivers to use the proper calls to query things like the
> protection interval, reference tag seed value, etc.

Hi Martin,

Do you plan to queue or repost this patch series?

Thanks,

Bart.
