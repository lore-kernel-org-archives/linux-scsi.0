Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88FD8C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 05:24:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57F2460F92
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Oct 2021 05:24:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233375AbhJZF0Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Oct 2021 01:26:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230501AbhJZF0Z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2021 01:26:25 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45C9AC061745;
        Mon, 25 Oct 2021 22:24:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=plVWDLn7kPJQFEKfT8/7o3CqD6r6OVtsqab9yP+KjBU=; b=4wMqJo3PGbg3IbF6ylQxYeHeUt
        sIsxI0L39G1XTAX/fnsTuLKdDriDi8VCDU9Om/OGCREp6aFTsHSGvvL8qAmTPy8DXbFZiqwdcuHwC
        yA8yq46fynherC+vf02tW2jXsrldSLPAQLLMjjYTIE6fJzVH7qOq5yOInYz+yrkKVncE01GcLi8AK
        hX5RHCEr30j7fEhIyqE8oyEnABTfMU1cBok4aH5ZPM6XnnWEl9vTPVVpftDKldbtdDIoSIkfxfUfT
        I5iX+Xy0hgT6eSmFsPqsD5Ki10sbNxu01tdRrzvURTRreDbh6rS8pAzzDOVo20sn0TZpm6ApUSsWr
        fDOUSlnQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfEwI-000fMv-Fv; Tue, 26 Oct 2021 05:23:58 +0000
Subject: Re: [PATCH] scsi: ufs: clean up the Kconfig file
To:     Bart Van Assche <bvanassche@acm.org>, linux-kernel@vger.kernel.org
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20211024064332.16360-1-rdunlap@infradead.org>
 <8578e393-2a25-bc52-65ea-599d071387e9@acm.org>
 <5b13f32c-0cdb-26de-2bb7-af56a099b0b2@infradead.org>
 <b3344662-03a7-43ca-21ea-7e2c4f0f658a@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <25efc8f3-d360-d6bd-47db-34e6c88481e3@infradead.org>
Date:   Mon, 25 Oct 2021 22:23:57 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <b3344662-03a7-43ca-21ea-7e2c4f0f658a@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart--

On 10/24/21 6:17 PM, Bart Van Assche wrote:
> On 10/24/21 16:35, Randy Dunlap wrote:
>> On 10/24/21 2:29 PM, Bart Van Assche wrote:
>>> On 10/23/21 23:43, Randy Dunlap wrote:
>>>>         sure that you know the name of your UFS host adapter (the card
>>>>         inside your computer that "speaks" the UFS protocol, also
>>>>         called UFS Host Controller), because you will be asked for it.
>>>> @@ -51,7 +50,7 @@ config SCSI_UFSHCD
>>>>         (the one containing the directory /) is located on a UFS device.
>>>>   config SCSI_UFSHCD_PCI
>>>> -    tristate "PCI bus based UFS Controller support"
>>>> +    tristate "PCI bus-based UFS Controller support"
>>>
>>> Even with this change applied capitalization is inconsistent.
>>
>> I don't doubt it, but could you be more explicit about
>> which word(s) you mean, please?
>>
>> I see one "pci" in the Kconfig file.

I changed that one. ^^^

>> I see several "Controller" vs. "controller."
>> I see a few of "Support" vs. "support."
>>
>> Which are you referring to? (or something else)
> 
> I was referring to the word "Controller". Although English is not my native
> language, shouldn't "UFS Controller" be changed into "UFS controller" since
> neither "bus-based" nor "support" are capitalized?

That's not so clear to me, but then I don't have access to the UFS specs.

This help text:
	  UFS host adapter (the card
	  inside your computer that "speaks" the UFS protocol, also
	  called UFS Host Controller)

might imply that the spec calls it "UFS Host Controller", but I can't
read it (AFAIK). OTOH, if that's just a common (non-spec) name for it,
then yes, it should be in lower case ("controller").

I'm leaning towards using "controller" everywhere -- or not changing
any of them. :)
Oh well.

Do you have any insights into this?

thanks.
-- 
~Randy
