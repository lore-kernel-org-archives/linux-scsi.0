Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27FBBC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 23:35:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEDDB61002
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 23:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbhJXXiJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 19:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229533AbhJXXiI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 24 Oct 2021 19:38:08 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DF4CC061745;
        Sun, 24 Oct 2021 16:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=vojAuA0zWMRXeMKM5FxwLkBGAJx4XzX1DoS3E/l+TR0=; b=WUs8HXwAmUMisHaiHQeTYLKozq
        JaBHeB0Uim6oNL+9a5VryUfm88jMIX9SjpcfFY1+ld58tTr1jij2ZzC1sPaXwZZ255f24aF6+I7bQ
        MrcQhLisdadLzgot9iIuVD38gaYv9nV1zTphcBALgsPjRvaTsN9FH++eKsC5k4xG8I9/KRTBRxoM1
        VVrs1SPcL+C01ALzKz8/3ydimYBAduzy0SVyHEF9Lk2M+Bn7zFcSJqcYoBYc58tkmj0f9CCk9Foxa
        qzeN5+zK8TL0SjT6VDHEf57aeNts5fpg9tC0TUcZy+fudlpNsSjb6XR3nLi4AwQ3k8h15uDfD6RaV
        wWigPwYg==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1men1j-00Emhv-Ta; Sun, 24 Oct 2021 23:35:43 +0000
Subject: Re: [PATCH] scsi: ufs: clean up the Kconfig file
To:     Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20211024064332.16360-1-rdunlap@infradead.org>
 <8578e393-2a25-bc52-65ea-599d071387e9@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <5b13f32c-0cdb-26de-2bb7-af56a099b0b2@infradead.org>
Date:   Sun, 24 Oct 2021 16:35:43 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <8578e393-2a25-bc52-65ea-599d071387e9@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/21 2:29 PM, Bart Van Assche wrote:
> On 10/23/21 23:43, Randy Dunlap wrote:
>> @@ -39,7 +38,7 @@ config SCSI_UFSHCD
>>       select DEVFREQ_GOV_SIMPLE_ONDEMAND
>>       select NLS
>>       help
>> -      This selects the support for UFS devices in Linux, say Y and make
>> +      This selects the support for UFS devices in Linux. Say Y and make
> 
> How about changing "This selects the support for UFS devices in Linux"
> into "Enables support for UFS devices"? "the" should be left out from a
> grammatical point of view and "in Linux" is redundant.

OK, done (locally).

>>         sure that you know the name of your UFS host adapter (the card
>>         inside your computer that "speaks" the UFS protocol, also
>>         called UFS Host Controller), because you will be asked for it.
>> @@ -51,7 +50,7 @@ config SCSI_UFSHCD
>>         (the one containing the directory /) is located on a UFS device.
>>   config SCSI_UFSHCD_PCI
>> -    tristate "PCI bus based UFS Controller support"
>> +    tristate "PCI bus-based UFS Controller support"
> 
> Even with this change applied capitalization is inconsistent.

I don't doubt it, but could you be more explicit about
which word(s) you mean, please?

I see one "pci" in the Kconfig file.
I see several "Controller" vs. "controller."
I see a few of "Support" vs. "support."

Which are you referring to? (or something else)

thanks.
-- 
~Randy
