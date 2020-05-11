Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26626C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:13:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 02AF3207DD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbgEKGNR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 02:13:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:45724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726661AbgEKGNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 02:13:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 5E67FABD1;
        Mon, 11 May 2020 06:13:18 +0000 (UTC)
Subject: Re: [PATCH 08/15] target: use tpt_id in
 target_stat_iport_port_ident_show
To:     Mike Christie <mchristi@redhat.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-9-mchristi@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <bb56c8de-9bdb-e929-7184-c3858706b978@suse.de>
Date:   Mon, 11 May 2020 08:13:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200510215744.21999-9-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> Use the tpt_id session id instead of sess_get_initiator_sid.
> 
> Note that for userspace compat this patch continues the behavior:
> 
> 1. Still add the "+i+" even if there is no session_id.
> 2. Use the acl initiatorname instead of the transportID port/addr/name.
> 
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
>   drivers/target/target_core_stat.c | 12 +++---------
>   1 file changed, 3 insertions(+), 9 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
