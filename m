Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C9E6C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:35:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0713F613D0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Sep 2021 09:35:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245090AbhI2Jgk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Sep 2021 05:36:40 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:47859 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229487AbhI2Jgj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 29 Sep 2021 05:36:39 -0400
Received: from [192.168.0.3] (ip5f5aef97.dynamic.kabel-deutschland.de [95.90.239.151])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 037D961E64761;
        Wed, 29 Sep 2021 11:34:57 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH V2 00/11] smartpqi updates
To:     Don Brace <don.brace@microchip.com>
Cc:     Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        balsundar.p@microchip.com, joseph.szczypek@hpe.com,
        jeff@canonical.com, POSWALD@suse.com, john.p.donnelly@oracle.com,
        mwilck@suse.com, linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210928235442.201875-1-don.brace@microchip.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <dfea334a-5d37-bb14-1959-51bf7287197b@molgen.mpg.de>
Date:   Wed, 29 Sep 2021 11:34:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20210928235442.201875-1-don.brace@microchip.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,


Just a small nit regarding most patches in the patch queue.

It’d be great if the full text width of 75 characters could be used in 
the commit message bodies. Currently they are well below that, and 
therefore take more lines than necessary and are harder to read for me.


Kind regards,

Paul
