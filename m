Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2880FC2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:02:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0CC242076A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:02:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504298AbgDPKCQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 06:02:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:46964 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504310AbgDPKCP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 06:02:15 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 455F5AD71;
        Thu, 16 Apr 2020 10:02:12 +0000 (UTC)
Subject: Re: [PATCH v3 30/31] elx: efct: Add Makefile and Kconfig for efct
 driver
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-31-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <dcb5f386-0b47-70c1-96b3-88c15278e9d5@suse.de>
Date:   Thu, 16 Apr 2020 12:02:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-31-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:33 AM, James Smart wrote:
> This patch completes the efct driver population.
> 
> This patch adds driver definitions for:
> Adds the efct driver Kconfig and Makefiles
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Use SPDX license
>    Remove utils.c from makefile
> ---
>   drivers/scsi/elx/Kconfig  |  9 +++++++++
>   drivers/scsi/elx/Makefile | 18 ++++++++++++++++++
>   2 files changed, 27 insertions(+)
>   create mode 100644 drivers/scsi/elx/Kconfig
>   create mode 100644 drivers/scsi/elx/Makefile
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
