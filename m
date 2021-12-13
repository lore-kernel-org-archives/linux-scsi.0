Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C21EC433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Dec 2021 03:06:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231406AbhLMDGq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Dec 2021 22:06:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231391AbhLMDGq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Dec 2021 22:06:46 -0500
Received: from desiato.infradead.org (desiato.infradead.org [IPv6:2001:8b0:10b:1:d65d:64ff:fe57:4e05])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AEA0C06173F
        for <linux-scsi@vger.kernel.org>; Sun, 12 Dec 2021 19:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=AF+y//9yjMDsX/lu+xCy80t+2ZmC/72PNU9bpSJgKjY=; b=UDhVoZJcMiT7UNkH4tGidfXQoW
        +97yYKcwhkQ7TkiXmaeJ2WrXNiW91JzGLaxQop0V1pmarr2Lyt35MwT7QrvDQZwONuLlGoX+B2Sgj
        Trf0eidNJ5ippGhZkfTF2sX2TDLD6qc9rqeyumUeHm9i7/37LDv5CS/nF+XanEzR/d0V/3AViDeBk
        kjp22C4oCE8kIjuScrw14RZJm/zTEwzlIQdGVHfGVu4KorOlxHoWEBlp57yQ4vVJrNVAqWozWuCoW
        0wtqmx2fIWRxQ6HZt1lugM36soHNOMkXsb1ra7cj4ha4ZsTykd9uTXtqbPDMsXXotxrlDSuQDp4OJ
        mFS64cKw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by desiato.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mwbfk-0013BT-K5; Mon, 13 Dec 2021 03:06:41 +0000
Message-ID: <64c22c93-a376-f6bc-c2b3-419912834605@infradead.org>
Date:   Sun, 12 Dec 2021 19:06:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH v2 01/12] scsi: core: Suppress a kernel-doc warning
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211129194609.3466071-1-bvanassche@acm.org>
 <20211129194609.3466071-2-bvanassche@acm.org>
 <393c6d58-8af5-5849-7962-64153e3ec290@infradead.org>
 <1ad52cc7-f736-6e75-36e0-414ac32f70b4@acm.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1ad52cc7-f736-6e75-36e0-414ac32f70b4@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 12/12/21 19:03, Bart Van Assche wrote:
> On 12/12/21 18:53, Randy Dunlap wrote:
>> On 11/29/21 11:45, Bart Van Assche wrote:
>>> -/**
>>> +/*
>>>    * scsi_enable_async_suspend - Enable async suspend and resume
>>>    */
>>>   void scsi_enable_async_suspend(struct device *dev)
>>>
>>
>> Why this instead of describing @dev: ?
>>
>>   * @dev: the struct device to enable for async suspend and resume
> 
> Hi Randy,
> 
> I expect that anyone can guess the meaning of the @dev argument without adding any explanation. Hence the choice to convert the kernel-doc comment into a regular comment.

That's probably true, but we do try to document (using kernel-doc)
non-static functions for other people's use.

Oh well. Thanks.

-- 
~Randy
