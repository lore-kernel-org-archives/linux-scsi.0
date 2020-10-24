Return-Path: <SRS0=Jnta=D7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6730CC2D0A3
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 03:55:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2A4F821D43
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Oct 2020 03:55:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759439AbgJXDym (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Oct 2020 23:54:42 -0400
Received: from mail-pj1-f45.google.com ([209.85.216.45]:40814 "EHLO
        mail-pj1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1759434AbgJXDym (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Oct 2020 23:54:42 -0400
Received: by mail-pj1-f45.google.com with SMTP id l2so265267pjt.5;
        Fri, 23 Oct 2020 20:54:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Suvd71l3PIMDym64qMv85dhFTEWotVujUwdwoB2OxHs=;
        b=S/bZ2tobvnjx3xxwUSSQhSHZFFPA3j1t7+E3R43SY7LWUnStXAcHMUbtmcDWKw7eB1
         GbAwI9EBe0S0ODfw0KWohZIyKrBBnLx+ZPJn6WiBZkRYoRVyElZvLkMKNP3SDob/lkEA
         pvo8SEBVFRUEM17yLYjDVMSnN/OA48ylUniYXbXogK06ZsqEb0mUdeCs9Tyl2JX+3YrG
         JMfQQrckq1YfPw6oqY9kX5Iy+WvcFrBfk7JqjPJdtgXEFhbv2FMCDqFNkTr3BhdkwLYp
         d77VqKXAZ/NvjRJ0X966sztlZK9stD7xn59+CWFYv7AXuLOw+2mD6R13z6Xp4og2deAl
         Hgzw==
X-Gm-Message-State: AOAM533u/5R++wc8Mg22/d+bHHrJXUzNv9TLWw0HlnLuVXBsJoUv5tRE
        Xz2Ygz1aOGg2Jr3LviiDKYDRIKLMQNXlUQ==
X-Google-Smtp-Source: ABdhPJzrSAJ3XDaWUf9/abihU8oq1RKzuUKHeCgVaV/Zfv2CinVEMZVBsN/ODtcEVRD306mwnpWwBA==
X-Received: by 2002:a17:90a:4742:: with SMTP id y2mr6046934pjg.228.1603511681320;
        Fri, 23 Oct 2020 20:54:41 -0700 (PDT)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y14sm3749893pfe.107.2020.10.23.20.54.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2020 20:54:40 -0700 (PDT)
Subject: Re: [PATCH 0/3] scsi: target: Set correct residual data
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com
References: <20201022172011.42367-1-a.kovaleva@yadro.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d9d0046a-b4b5-0f61-5761-0cb27e968c3a@acm.org>
Date:   Fri, 23 Oct 2020 20:54:38 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201022172011.42367-1-a.kovaleva@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/22/20 10:20 AM, Anastasia Kovaleva wrote:
> The link to the pull request:
> https://github.com/sahlberg/libiscsi/pull/345

I'm not going to merge that pull request without significant changes.
See also the comment that I added on the pull request on github.

Bart.
