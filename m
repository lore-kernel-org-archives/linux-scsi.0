Return-Path: <SRS0=09q6=EO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3460C388F2
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 08:11:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC9A2206F4
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Nov 2020 08:11:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726144AbgKHILG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Nov 2020 03:11:06 -0500
Received: from mx3.molgen.mpg.de ([141.14.17.11]:46679 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726062AbgKHILG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 8 Nov 2020 03:11:06 -0500
Received: from [192.168.0.2] (ip5f5af19e.dynamic.kabel-deutschland.de [95.90.241.158])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id D01372064621D;
        Sun,  8 Nov 2020 09:11:02 +0100 (CET)
Subject: Re: Linux 5.9: smartpqi: controller is offline: status code 0x6100c
To:     Don.Brace@microchip.com, don.brace@microsemi.com
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        esc.storagedev@microsemi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, it+linux-scsi@molgen.mpg.de,
        Donald Buczek <buczek@molgen.mpg.de>
References: <bc10fad1-2353-7326-c782-7a45882fd791@molgen.mpg.de>
 <SN6PR11MB28482195705A64E8F8ECD52AE1030@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <a2ed59e8-30a4-7f5c-c794-0f6aff8b6456@molgen.mpg.de>
Date:   Sun, 8 Nov 2020 09:11:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.1
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB28482195705A64E8F8ECD52AE1030@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Dear Don,


Am 17.10.20 um 00:31 schrieb Don.Brace@microchip.com:
> The 6100C lockup is the result of the controller running out of
> commands to process new incoming requests from the driver.
> 
> We are actively looking into this issue.

Unfortunately, there has not been any further reply by the Microsemi 
support, and the driver 1.2.14-016 does not built against Linux 5.9 or 
master.

Were you able to reproduce the issue? What is the timeline to getting 
this fixed?

Linux 5.10 is going to be a long-term support release, so it would be 
great to have the problems fixed as soon as possible.


Kind regards,

Paul
