Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F21E1C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Jul 2022 20:35:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237214AbiGYUfZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Jul 2022 16:35:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237194AbiGYUfY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2022 16:35:24 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6880E115F
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 13:35:21 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t17so7540735lfk.0
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2022 13:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kF+g+F7mYcIUaJYAQWrmzn8M6Wb/+yPNGEuaPjJTuM4=;
        b=c1E4ypsrj4lfQjVDS1PjLkofXsBCBIYDZ1iSIrtIkmc6jnYy+Q+NdEG9xEhHz7sCTb
         7S8gZR6Kr0566YVA6fqyBfHCGzMq0XTU6LjPzw+gKr9GarCxMwFKil9NrN5y5MNqZi25
         23ZJNUw8tky4+kkjcWOway9aElUecKZBb9L80dv2B1iSCGvkn3+n5Evi0EkUBb6kQcoa
         k4Dg9URTwEyonbgRpBNIgMlnNq9XkMWZVoHVhPinK1jsRrVO6eO9XgfrAGw2XsL+bgcn
         jgo9TAy/07Pet6Ww4BN6yscaYs/KCpunHCdXKQKkwd3FEsFvJjZHS9XJFEyAOogPD16E
         rUgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kF+g+F7mYcIUaJYAQWrmzn8M6Wb/+yPNGEuaPjJTuM4=;
        b=EKXCJcS0qS8dwqEsa4gzlAhAR1CO+mtGBR9L07dC4knjW8cb6YgkXmLBJNmFld+v7T
         uL5FwJg0ejnTE6J1gkRMgq1t8DnKbn+so5+yU96iN6ERtVOrH42u0sdSdCjQY8NKnINV
         gKaPntq/KhPkofvIxP/yclbNoN2yGKRGcJkk8OI79O7iArcFd+pLdOVy1TiC22VNJXzm
         PVtUj6dS6DF7LOEKDzi5ripTLs4lTZmRwwYvCivb7FPwqF5If73DVAXOD4R+AG0BecRa
         xOq6gBG5+lam4stsxu29MmFlAy9INLBW6wK3XCBt9t32MUUJAF0I1lGVbtzENA++tMrT
         gAYw==
X-Gm-Message-State: AJIora8c1datvjVsl7Hfpmuo9d2OxyMxpAaAdEC2g593GFWtHkxApbmD
        Kzb7Fd5QSzRcxBN78mV1uKJaZQ==
X-Google-Smtp-Source: AGRyM1ttV6py/cPAH9tBoi/teqtLFo+O1OebISYGtEbEAaJj118/1dMgrgbrEF7axMWM/vp84mGJqg==
X-Received: by 2002:a05:6512:2302:b0:489:da47:6a90 with SMTP id o2-20020a056512230200b00489da476a90mr4974106lfu.12.1658781319674;
        Mon, 25 Jul 2022 13:35:19 -0700 (PDT)
Received: from [192.168.3.197] (78-26-46-173.network.trollfjord.no. [78.26.46.173])
        by smtp.gmail.com with ESMTPSA id s7-20020a05651c200700b0025deb36756dsm2339404ljo.103.2022.07.25.13.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Jul 2022 13:35:19 -0700 (PDT)
Message-ID: <ea2cc75c-611f-f612-e692-325fb7e98d6b@linaro.org>
Date:   Mon, 25 Jul 2022 22:35:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] dt-bindings: ufs: qcom,ufs: add SC8280XP binding
Content-Language: en-US
To:     Johan Hovold <johan@kernel.org>, Rob Herring <robh@kernel.org>
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220711101441.4896-1-johan+linaro@kernel.org>
 <Yt5+EU529KriiAvE@hovoldconsulting.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <Yt5+EU529KriiAvE@hovoldconsulting.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/07/2022 13:27, Johan Hovold wrote:
> On Mon, Jul 11, 2022 at 12:14:41PM +0200, Johan Hovold wrote:
>> Add SC8280XP to the DT schema.
>>
>> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> ---
> 
> Rob,
> 
> Will you be picking this one up?
> 
> There doesn't seem to be any other maintainers listed for this file in
> case it's expected to go through some other tree.
> 

The preference is that it should go via subsystem and get_maintainers.pl
points Alimi, Avri and Bart. However in the past it seems indeed Rob was
picking it up...


Best regards,
Krzysztof
