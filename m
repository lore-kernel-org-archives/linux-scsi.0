Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8A3C433E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:30:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01D9922A84
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 07:30:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727605AbhAKHaB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 02:30:01 -0500
Received: from mx2.suse.de ([195.135.220.15]:49464 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbhAKHaA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 02:30:00 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 015F6AB3E;
        Mon, 11 Jan 2021 07:29:19 +0000 (UTC)
Subject: Re: [PATCH v7 01/16] cgroup: Added cgroup_get_from_id
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1609970430-19084-1-git-send-email-muneendra.kumar@broadcom.com>
 <1609970430-19084-2-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0a1453c2-9f8a-0818-1678-78e1775a773b@suse.de>
Date:   Mon, 11 Jan 2021 08:29:17 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1609970430-19084-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/6/21 11:00 PM, Muneendra wrote:
> Added a new function cgroup_get_from_id  to retrieve the cgroup
> associated with cgroup id.
> Exported the same as this can be used by blk-cgorup.c
> 
> Added function declaration of cgroup_get_from_id in cgorup.h
> 
> This patch also exported the function cgroup_get_e_css
> as this is getting used in blk-cgroup.h
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> renamed the function cgroup_get_from_kernfs_id to
> cgroup_get_from_id
> 
> v4:
> No change
> 
> v3:
> Exported the cgroup_get_e_css
> 
> v2:
> New patch
> ---
>   include/linux/cgroup.h |  6 ++++++
>   kernel/cgroup/cgroup.c | 26 ++++++++++++++++++++++++++
>   2 files changed, 32 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
