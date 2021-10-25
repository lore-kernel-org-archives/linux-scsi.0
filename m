Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDC08C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:18:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9856E60FBF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 01:18:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhJYBUW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 21:20:22 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:40560 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbhJYBUV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 21:20:21 -0400
Received: by mail-pl1-f172.google.com with SMTP id v20so6791729plo.7;
        Sun, 24 Oct 2021 18:18:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=q5O4UBSKbAyhKsuzmZP4VB7n8u3QEGlpbp2iyZiAqqw=;
        b=yIF/T8DkWDnLNSlBoGqMolkl1hNA4F/QTC+COaxH6rxwZG6SM2KnkI8N53POe5pN+6
         s3qaRTvhL2qGX0ZIAx3IR8bN0Xr3+wyAJxsJjCYbOMu1HIr1O7MmsP4/6ZOF8B1v9SWW
         HXbrDdNdMwqVcd7tZDgO58IwTD2YBN4CaFA2Q4o5eizuCjxSM7bnxs+NsXF+iGiCEVq3
         lReNZPNqtpRlH1uqpES6ZNPN0oRHqnjomBloLecwJeaNqXlDxHcAvSrnZFlrL8wBVi2O
         HcaT2JF1bTxZ81kTkoy5uIa5yHDdP+O2aszU/nj7Ye+Bgy1PhDhiiXG2rqoeFkX0hwYb
         qkXw==
X-Gm-Message-State: AOAM532xnp3HOJslCmfrs1ZgdIXxl4kZyU3kZtHO16+miR5FPw/zr1yp
        3A8zF3PRML0B4RZwt+zBERs=
X-Google-Smtp-Source: ABdhPJzUd1g7LQesE692U+SJJhHOV3woPCI/hMm1zSuEzf+KYORHfg9HyJyHverPXkihxkZ6/oX8pQ==
X-Received: by 2002:a17:90a:d311:: with SMTP id p17mr2476735pju.95.1635124679565;
        Sun, 24 Oct 2021 18:17:59 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:1d23:4f1f:253d:c1e1? ([2601:647:4000:d7:1d23:4f1f:253d:c1e1])
        by smtp.gmail.com with ESMTPSA id z5sm14328623pge.2.2021.10.24.18.17.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 24 Oct 2021 18:17:58 -0700 (PDT)
Message-ID: <b3344662-03a7-43ca-21ea-7e2c4f0f658a@acm.org>
Date:   Sun, 24 Oct 2021 18:17:57 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH] scsi: ufs: clean up the Kconfig file
Content-Language: en-US
To:     Randy Dunlap <rdunlap@infradead.org>, linux-kernel@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20211024064332.16360-1-rdunlap@infradead.org>
 <8578e393-2a25-bc52-65ea-599d071387e9@acm.org>
 <5b13f32c-0cdb-26de-2bb7-af56a099b0b2@infradead.org>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5b13f32c-0cdb-26de-2bb7-af56a099b0b2@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/21 16:35, Randy Dunlap wrote:
> On 10/24/21 2:29 PM, Bart Van Assche wrote:
>> On 10/23/21 23:43, Randy Dunlap wrote:
>>>         sure that you know the name of your UFS host adapter (the card
>>>         inside your computer that "speaks" the UFS protocol, also
>>>         called UFS Host Controller), because you will be asked for it.
>>> @@ -51,7 +50,7 @@ config SCSI_UFSHCD
>>>         (the one containing the directory /) is located on a UFS device.
>>>   config SCSI_UFSHCD_PCI
>>> -    tristate "PCI bus based UFS Controller support"
>>> +    tristate "PCI bus-based UFS Controller support"
>>
>> Even with this change applied capitalization is inconsistent.
> 
> I don't doubt it, but could you be more explicit about
> which word(s) you mean, please?
> 
> I see one "pci" in the Kconfig file.
> I see several "Controller" vs. "controller."
> I see a few of "Support" vs. "support."
> 
> Which are you referring to? (or something else)

I was referring to the word "Controller". Although English is not my native
language, shouldn't "UFS Controller" be changed into "UFS controller" since
neither "bus-based" nor "support" are capitalized?

Thanks,

Bart.
