Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64483C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Dec 2021 00:27:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345741AbhLAAam (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Nov 2021 19:30:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345758AbhLAAaR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Nov 2021 19:30:17 -0500
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7870EC061574
        for <linux-scsi@vger.kernel.org>; Tue, 30 Nov 2021 16:26:56 -0800 (PST)
Subject: Re: [PATCH V2] scsi:spraid: initial commit of Ramaxel spraid driver
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1638318414;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aHR3SJhsIRdQiM1zYGof9e8EUy4VEfYog8dY5AZdwzM=;
        b=ebxt9wr003xvu/6ea8Wx2lqqQs+5BvyWfi0Okg35HIB0gT0HEFVmHSfKQYF4Y/b42MIYNC
        Yadnd+GAKnBWNwEfVsDDmPXRRrkZnE9BbjasajXvEI17iqNmjrdc1R3o0dUufxVhgcU3Wk
        4ohC1Kqo5IjgIp/OYQHyYTQuysLRjjk=
To:     Yanling Song <songyl@ramaxel.com>,
        Randy Dunlap <rdunlap@infradead.org>
Cc:     martin.petersen@oracle.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, yujiang@ramaxel.com
References: <20211126073310.87683-1-songyl@ramaxel.com>
 <05de8598-598f-629c-a553-a363f41014db@infradead.org>
 <20211130113449.45751209@songyl>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Yanling song <yanling.song@linux.dev>
Message-ID: <eabad84d-34e4-cc69-0aa1-24ef2200039b@linux.dev>
Date:   Wed, 1 Dec 2021 00:26:50 +0000
MIME-Version: 1.0
In-Reply-To: <20211130113449.45751209@songyl>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/30/21 11:34 AM, Yanling Song wrote:
> On Fri, 26 Nov 2021 11:24:10 -0800
> Randy Dunlap <rdunlap@infradead.org> wrote:
> 
>> Hi--
>>
>> On 11/25/21 11:33 PM, Yanling Song wrote:
>>> diff --git a/drivers/scsi/spraid/Kconfig
>>> b/drivers/scsi/spraid/Kconfig new file mode 100644
>>> index 000000000000..169412ef2299
>>> --- /dev/null
>>> +++ b/drivers/scsi/spraid/Kconfig
>>> @@ -0,0 +1,10 @@
>>> +#
>>> +# Ramaxel driver configuration
>>> +#
>>> +
>>> +config RAMAXEL_SPRAID
>>> +	tristate "Ramaxel spraid Adapter"
>>> +	depends on PCI && SCSI && BLK_DEV_BSGLIB  
>>
>> 	depends on PCI && SCSI
>> 	select BLK_DEV_BSGLIB
>>
>> should be OK since all other users of BLK_DEV_BSGLIB select it.
> 
> OK, will change to "select" in the next version
>>
>>> +	depends on ARM64 || X86_64
>>> +	help
>>> +	  This driver supports Ramaxel spraid driver.  
>>
>>
> 
Something wrong with my company's email(songyl@ramaxel.com), resend with another email account.
