Return-Path: <SRS0=c8H+=2A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE3C8C43603
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 16:10:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CEB3B20836
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Dec 2019 16:10:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727495AbfLJQKh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Dec 2019 11:10:37 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:44877 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727178AbfLJQKh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Dec 2019 11:10:37 -0500
Received: by mail-qk1-f195.google.com with SMTP id w127so5053472qkb.11;
        Tue, 10 Dec 2019 08:10:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lZE47SpvmWbaZCLW9SF04UfyFA5hnwe7EynLuzbBXEU=;
        b=QE1w6CNXmkuHy57MqPqKfNMMXwOwNrbJirtcE9psbiCsDc6rzaAfRnk8ihzFMEoaVL
         MImPsc1IFDFfKNxvxw8FxBdVGma5DsAA/P544nWiJluscH2NGd1C53wzVzi+UFpTj7yK
         dyu0I8QvSK1WhUrYVr4q56xtAfcsy5twl0EB4L82q/T4zwzZ00+LAtX3xTC8L8RzQ50r
         wc/+Xihw//FIWXVdWaO816ZvrsRu+BOWxYtNTfg9lj9Y7CuBBxcLo5lsaE7IvFZaYTVr
         clwDAtMvG6ICFJ1X0o9+TLqYM+9rNgOa6gw3xRdQCu0eaQaKP9V/zgO5PY9HYCwYVShP
         DRAw==
X-Gm-Message-State: APjAAAUooKSLt5k1s4hUaWz+H4SeKft+JsmyGLB1vmXbUQbrlZmD0ZYE
        jRIt16oL8eCTwJGEKHL4GBw=
X-Google-Smtp-Source: APXvYqwtb+bh5ogy/mgbL/ALEUxzw0JUumrhq01yBDoTtXEUY99U0X4eCKZqwQE7q8Md9k5/c1fofg==
X-Received: by 2002:a37:6d47:: with SMTP id i68mr20525610qkc.228.1575994235780;
        Tue, 10 Dec 2019 08:10:35 -0800 (PST)
Received: from ?IPv6:2620:0:1003:512:62e9:2658:28c:bd76? ([2620:0:1003:512:62e9:2658:28c:bd76])
        by smtp.gmail.com with ESMTPSA id g9sm1052744qkm.9.2019.12.10.08.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Dec 2019 08:10:34 -0800 (PST)
Subject: Re: [PATCH 1/1] hwmon: Driver for temperature sensors on SATA drives
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-hwmon@vger.kernel.org, Jean Delvare <jdelvare@suse.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        Chris Healy <cphealy@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>
References: <20191209052119.32072-1-linux@roeck-us.net>
 <20191209052119.32072-2-linux@roeck-us.net>
 <c87ca545-d8f1-bf1e-2474-b98a6eb60422@acm.org>
 <20191209192048.GA3940@roeck-us.net>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <ad33d8cb-5247-0bf8-d0cb-87073a41e3ff@acm.org>
Date:   Tue, 10 Dec 2019 11:10:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191209192048.GA3940@roeck-us.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/19 2:20 PM, Guenter Roeck wrote:
> On Mon, Dec 09, 2019 at 09:08:13AM -0800, Bart Van Assche wrote:
>> How much does synchronously submitting SCSI commands from inside the
>> device probing call back slow down SCSI device discovery? What is the
>> impact of this code on systems with a large number of ATA devices?
> 
> Interesting question. In general, any SCSI commands would only be executed
> for SATA drives since the very first check in satatemp_identify() uses
> sdev->inquiriy and aborts if the drive in question is not an ATA drive.
> When connected to SATA drives, I measured the execution time of
> satatemp_identify() to be between ~900 uS and 1,700 uS on a system with
> Ryzen 3900 CPU.
> 
> In more detail:
> - Time to read VPD page: ~10-20 uS
> - Time to execute SMART_READ_LOG/SCT_STATUS_REQ_ADDR: ~140-150 uS
> - Time to execute SMART_WRITE_LOG/SCT_STATUS_REQ_ADDR: ~600-1,500 uS
> - Time to execute SMART_READ_LOG/SCT_READ_LOG_ADDR: ~100-130 uS
> 
> Does that answer your question ?
> 
> Please note that I think that this is irrelevant in this context.
> The driver is only instantiated if loaded explicitly, so whoever uses it
> will be in a position to decide if the benefit of using it will outweigh
> its cost.
> 
> If instantiation time ever becomes a real problem, for example if someone
> with a large number of SATA drives in a system wants to use the driver
> and is concerned about instantiation time, we can make the second part
> of its registration (ie everything after identifying SATA drives)
> asynchronous. That would, however, add a substantial amount of complexity
> to the driver, and we should only do it if it is really warranted.

Hi Guenter,

Thank you for having answered my question in great detail. I think this
overhead is low enough to be acceptable.

Bart.
