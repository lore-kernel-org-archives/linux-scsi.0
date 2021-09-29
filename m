Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F363C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 14:13:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 239F1613A7
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 14:13:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343500AbhI2OOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 10:14:42 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:41823 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S245475AbhI2OOm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 10:14:42 -0400
Received: from [192.168.0.3] (ip5f5aef97.dynamic.kabel-deutschland.de [95.90.239.151])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id A8D5D61E6478B;
        Wed, 29 Sep 2021 16:12:58 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH V2 00/11] smartpqi updates
To:     Don.Brace@microchip.com
Cc:     Kevin.Barnett@microchip.com, Scott.Teel@microchip.com,
        Justin.Lindley@microchip.com, Scott.Benesh@microchip.com,
        Gerry.Morong@microchip.com, Mahesh.Rajashekhara@microchip.com,
        Mike.McGowen@microchip.com, Murthy.Bhat@microchip.com,
        Balsundar.P@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
 <dfea334a-5d37-bb14-1959-51bf7287197b@molgen.mpg.de>
 <SN6PR11MB2848FE480F24EF105E473F4EE1A99@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <99b812a8-6ade-0b29-bcb4-a0e4575ea550@molgen.mpg.de>
Date:   Wed, 29 Sep 2021 16:12:58 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB2848FE480F24EF105E473F4EE1A99@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,


Am 29.09.21 um 16:08 schrieb Don.Brace@microchip.com:
> -----Original Message-----
> From: Paul Menzel [mailto:pmenzel@molgen.mpg.de]
> Subject: Re: [smartpqi updates PATCH V2 00/11] smartpqi updates
> 
> Dear Don,
> 
> 
> Just a small nit regarding most patches in the patch queue.
> 
> It’d be great if the full text width of 75 characters could be used in the commit message bodies. Currently they are well below that, and therefore take more lines than necessary and are harder to read for me.
> 
> 
> Kind regards,
> 
> Paul
> ---
> I can re-word and re-send if you like.

If you sent V3 due to other reasons, then yes. Otherwise, please just 
keep it in mind for the future.


Kind regards,

Paul
