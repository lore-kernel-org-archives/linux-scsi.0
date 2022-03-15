Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE21DC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 18:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236125AbiCOSUk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 14:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiCOSUk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 14:20:40 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22903593AD;
        Tue, 15 Mar 2022 11:19:27 -0700 (PDT)
Received: from [192.168.0.3] (ip5f5ae8f9.dynamic.kabel-deutschland.de [95.90.232.249])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 2E34D61EA1928;
        Tue, 15 Mar 2022 19:19:23 +0100 (CET)
Message-ID: <6447db26-5e0e-1b71-c4da-abbe8e4e219a@molgen.mpg.de>
Date:   Tue, 15 Mar 2022 19:19:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v2] scsi: 3w-sas: Correct log level of several messages
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220315060459.133090-1-pmenzel@molgen.mpg.de>
 <yq17d8vay0y.fsf@ca-mkp.ca.oracle.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <yq17d8vay0y.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Martin,


Am 15.03.22 um 19:15 schrieb Martin K. Petersen:

>> -		printk(KERN_WARNING "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
>> +		printk(KERN_INFO "3w-sas:%s AEN: %s (0x%02X:0x%04X): %s:%s.\n",
> 
> Maybe it would be worth considering a switch to dev_info()/pr_info() and
> friends while you're at it?

I thought about it, but took a step back as other things are currently 
more pressing here. Sorry.


Kind regards,

Paul
