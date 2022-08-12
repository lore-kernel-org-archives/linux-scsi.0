Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BB1EC00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 06:00:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237090AbiHLGAI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 02:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiHLF77 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 01:59:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E6BA4053;
        Thu, 11 Aug 2022 22:59:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F556B82368;
        Fri, 12 Aug 2022 05:59:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79AAC433C1;
        Fri, 12 Aug 2022 05:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660283996;
        bh=D+ySA4unPGJQAklQXAJt4uixwoAh+InIUtaelnM8bGs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=bT7SIxwnvwgmaw/q7kAJ13cbwES9DzRFH7rsEyu+eeCC4f/UnWL37gOPKt0e7cgNW
         Yur4pt2QxsWFkkFmT5o7tO0eBAsKiCOFKrTGkyWHATGpFsOm2Zf7n8R4/QtCM71sz4
         Ar/zpMpcgmdu7LwsHrpulGrvg4KPBCxB03/t9HbKDFsdytcAYyQgfHu1W+RohDIIGf
         N2gwUyn89VQg8twkc60FR/yG2eJBN+rSQZJZFSKfekzcaUI8EulWCkHtdtWdJGvlBV
         Ra+BK7IC8gW2sOqF7/nYaYxu/sBMWL42eKTIspPJUi7BzP7sOo5IKtaG/5uVL08YKw
         6+NWicYMfvk0Q==
Message-ID: <e874a457-48a1-c9b5-3cd9-ead270103335@kernel.org>
Date:   Fri, 12 Aug 2022 13:59:52 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] scsi: support packing multi-segment in UNMAP command
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, hch@infradead.org
References: <20220616013617.2284341-1-chao@kernel.org>
 <yq1wndgnj4i.fsf@ca-mkp.ca.oracle.com>
 <a15badd3-b9db-929f-1dc2-863fbff03992@acm.org>
 <yq1r11mmdpi.fsf@ca-mkp.ca.oracle.com>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <yq1r11mmdpi.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On 2022/8/12 9:53, Martin K. Petersen wrote:
> 
> Bart,
> 
>> Have you already had the chance to test this patch? We would like to
>> use this functionality in Android.
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkp/linux.git/log/?h=5.20/discovery
> 
> Had to drop the series from 5.20/6.0 due to a couple of reported
> regressions. Will try again for 6.1.

Could you please provider details of regression reports, let me check them
as well.

Thanks,
