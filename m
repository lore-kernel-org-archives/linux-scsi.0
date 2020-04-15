Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE8EAC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1EF7206A2
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 12:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S370356AbgDOMtn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 08:49:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:33164 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S370368AbgDOMtj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Apr 2020 08:49:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 24C47AC44;
        Wed, 15 Apr 2020 12:49:37 +0000 (UTC)
Subject: Re: [PATCH v3 07/31] elx: libefc_sli: APIs to setup SLI library
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-8-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <50a8fa4b-c688-a84d-a043-9a5216511edc@suse.de>
Date:   Wed, 15 Apr 2020 14:49:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200412033303.29574-8-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/12/20 5:32 AM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds APIS to initialize the library, initialize
> the SLI Port, reset firmware, terminate the SLI Port, and
> terminate the library.
> 
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v3:
>    Changed some function types to bool.
>    Return defined return values EFC_SUCCESS/FAIL
>    Defined dump types SLI4_FUNC_DESC_DUMP, SLI4_CHIP_LEVEL_DUMP.
>    Defined dump status return values for sli_dump_is_ready().
>    Formatted function defines to use 80 character length.
> ---
>   drivers/scsi/elx/libefc_sli/sli4.c | 1202 ++++++++++++++++++++++++++++++++++++
>   drivers/scsi/elx/libefc_sli/sli4.h |  434 +++++++++++++
>   2 files changed, 1636 insertions(+)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
