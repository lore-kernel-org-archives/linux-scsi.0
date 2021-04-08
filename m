Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01E8EC433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:34:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C2D9161165
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Apr 2021 08:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbhDHIfB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Apr 2021 04:35:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:41892 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229588AbhDHIfB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 8 Apr 2021 04:35:01 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9D8D7B01E;
        Thu,  8 Apr 2021 08:34:49 +0000 (UTC)
Subject: Re: [PATCH v9 01/13] cgroup: Added cgroup_get_from_id
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1617750397-26466-1-git-send-email-muneendra.kumar@broadcom.com>
 <1617750397-26466-2-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2e6ceb94-0620-2097-35de-57d8bf3a9f20@suse.de>
Date:   Thu, 8 Apr 2021 10:26:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1617750397-26466-2-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 1:06 AM, Muneendra wrote:
> Added a new function cgroup_get_from_id  to retrieve the cgroup
> associated with cgroup id.
> Exported the same as this can be used by blk-cgorup.c
> 
> Added function declaration of cgroup_get_from_id in cgorup.h
> 
> This patch also exported the function cgroup_get_e_css
> as this is getting used in blk-cgroup.h
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v9:
> Addressed the issues reported by kernel test robot
> 
> v8:
> No change
> 
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
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
