Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 600C6C433E9
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 18:40:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ED0F601FC
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 18:40:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234887AbhCASkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 13:40:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:58256 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240241AbhCASiU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 13:38:20 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 43AD6AD73;
        Mon,  1 Mar 2021 18:37:35 +0000 (UTC)
Subject: Re: [PATCH v5 03/31] elx: libefc_sli: Data structures and defines for
 mbox commands
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>
References: <20210103171134.39878-1-jsmart2021@gmail.com>
 <20210103171134.39878-4-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <86487cc5-e0c8-eede-dde2-42b8ca0229f1@suse.de>
Date:   Mon, 1 Mar 2021 19:37:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210103171134.39878-4-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/3/21 6:11 PM, James Smart wrote:
> This patch continues the libefc_sli SLI-4 library population.
> 
> This patch adds definitions for SLI-4 mailbox commands
> and responses.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
> ---
> v5:
>   Common naming for topology defines.
> ---
>   drivers/scsi/elx/libefc_sli/sli4.h | 1628 +++++++++++++++++++++++++++-
>   1 file changed, 1627 insertions(+), 1 deletion(-)
> 
Hmm. Curious that you still refer to ethernet; I hoped FCoe was dead ...
Guess one can but hope :-)

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
