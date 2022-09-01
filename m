Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D911ECAAD8
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Sep 2022 04:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229813AbiIAElN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Sep 2022 00:41:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiIAElM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2022 00:41:12 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 055BB7644F;
        Wed, 31 Aug 2022 21:41:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=tsM4k25GM4BwwXU6z3TF/EMT998kaXys+OXpMKtm2tE=; b=H2jHD48BwQsrZeZuv01EOyl4Nk
        veiO/GrOtXpxw/DcIIp39p0UxtuspGUmw6LARZaD3OL0n0CAjpjrNCIux/reyaz+H1wBiq7G61R9I
        E4RAnuWKn0W2E3aWeyuE8xcA2qmCzyGH/Y9OZa2VBynJzGvYRPa/O0xtFKAa8HvBtmYsgRS4tsRbg
        FDxgYzaXJg+3Wc8RsWh3E6FuLoPmTxeOgc3o96gqo9mas2vl6eWg5I/xBUIXv5teBsLlDV4cYnB3r
        BCSYQDXYxESGA0E3T40k4Ib00c6m12bRIw4gxryX1BXCqbesvl5QwmrttTKbec1ND7TkQxdTnUh/T
        3CnN83Wg==;
Received: from [2601:1c0:6280:3f0::a6b3]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oTc0o-009cWs-FN; Thu, 01 Sep 2022 04:41:06 +0000
Message-ID: <bfa99e6f-8c11-eec0-dfab-7779b74c801f@infradead.org>
Date:   Wed, 31 Aug 2022 21:41:05 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.0
Subject: Re: [PATCH] Documentation/SCSI: fix a few typos
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-doc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20220827221719.11006-1-rdunlap@infradead.org>
 <yq1wnanlnmm.fsf@ca-mkp.ca.oracle.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <yq1wnanlnmm.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 8/31/22 21:35, Martin K. Petersen wrote:
> 
> Randy,
> 
>> Correct some spelling typos in SCSI documentation.
> 
> Partially applied to 6.1/scsi-staging, thanks!
> 
>> --- a/Documentation/scsi/scsi_eh.rst
>> +++ b/Documentation/scsi/scsi_eh.rst
>> @@ -206,7 +206,7 @@ again.
>>  To achieve these goals, EH performs recovery actions with increasing
>>  severity.  Some actions are performed by issuing SCSI commands and
>>  others are performed by invoking one of the following fine-grained
>> -hostt EH callbacks.  Callbacks may be omitted and omitted ones are
>> +host EH callbacks.  Callbacks may be omitted and omitted ones are
>>  considered to fail always.
> 
> This one is correct, hostt is shorthand for "host template" in SCSI.

Aha. Thanks.

-- 
~Randy
