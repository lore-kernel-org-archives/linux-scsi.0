Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B244C433F7
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:04:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 578A02220F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:04:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgGNHEY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:04:24 -0400
Received: from mx2.suse.de ([195.135.220.15]:39558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726962AbgGNHEX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:04:23 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 4FE8AAD1E;
        Tue, 14 Jul 2020 07:04:24 +0000 (UTC)
Subject: Re: [PATCH v2 10/29] scsi: libfc: fc_lport: Repair function parameter
 documentation
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-11-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <17d4d3aa-aaf4-c12c-4de4-8fd759c66968@suse.de>
Date:   Tue, 14 Jul 2020 09:04:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-11-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Either misdocumentation and/or bitrot.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/libfc/fc_lport.c:412: warning: Function parameter or member 'in_fp' not described in 'fc_lport_recv_echo_req'
>   drivers/scsi/libfc/fc_lport.c:412: warning: Excess function parameter 'fp' description in 'fc_lport_recv_echo_req'
>   drivers/scsi/libfc/fc_lport.c:447: warning: Function parameter or member 'in_fp' not described in 'fc_lport_recv_rnid_req'
>   drivers/scsi/libfc/fc_lport.c:447: warning: Excess function parameter 'fp' description in 'fc_lport_recv_rnid_req'
>   drivers/scsi/libfc/fc_lport.c:1330: warning: Function parameter or member 'state' not described in 'fc_lport_enter_ns'
>   drivers/scsi/libfc/fc_lport.c:1428: warning: Function parameter or member 'state' not described in 'fc_lport_enter_ms'
>   drivers/scsi/libfc/fc_lport.c:1939: warning: Function parameter or member 'tov' not described in 'fc_lport_els_request'
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/libfc/fc_lport.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
