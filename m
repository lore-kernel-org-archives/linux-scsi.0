Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9995CC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:38:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 785862074F
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:38:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897562AbgDOMiL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:38:11 -0400
Received: from mx2.suse.de ([195.135.220.15]:56022 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2409086AbgDOMiA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 08:38:00 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A8681ADEB;
        Wed, 15 Apr 2020 12:37:58 +0000 (UTC)
Subject: Re: [PATCH v3 08/31] elx: libefc: Generic state machine framework
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-9-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <cb5ebc1b-b3bd-ae81-0155-f1b53a0a0d62@suse.de>
Date:   Wed, 15 Apr 2020 14:37:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-9-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch starts the population of the libefc library.
> The library will contain common tasks usable by a target or initiator
> driver. The library will also contain a FC discovery state machine
> interface.
> 
> This patch creates the library directory and adds definitions
> for the discovery state machine interface.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Removed efc_sm_id array which is not used.
>    Added State Machine event name lookup array.
> ---
>   drivers/scsi/elx/libefc/efc_sm.c |  61 ++++++++++++
>   drivers/scsi/elx/libefc/efc_sm.h | 209 +++++++++++++++++++++++++++++++++++++++
>   2 files changed, 270 insertions(+)
>   create mode 100644 drivers/scsi/elx/libefc/efc_sm.c
>   create mode 100644 drivers/scsi/elx/libefc/efc_sm.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
