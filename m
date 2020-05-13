Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 910CCC2D0FD
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 06:21:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D8F52176D
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 06:21:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbgEMGVd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 02:21:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:35960 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgEMGVc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 02:21:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id CD6A7ABBE;
        Wed, 13 May 2020 06:21:33 +0000 (UTC)
Subject: Re: [PATCH 3/5] megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro
 with __BIG_ENDIAN_BITFIELD macro
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com, "# v5 . 6+" <stable@vger.kernel.org>
References: <20200508085130.23339-1-chandrakanth.patil@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <8e1264db-bd78-a42e-2993-b0e6ef0ed91e@suse.de>
Date:   Wed, 13 May 2020 08:21:29 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508085130.23339-1-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/20 10:51 AM, Chandrakanth Patil wrote:
> MFI_BIG_ENDIAN macro used in drivers structure bitfield to check
> the CPU big endianness is undefined which would break the code on
> big endian machine. __BIG_ENDIAN_BITFIELD kernel macro should be
> used in places of MFI_BIG_ENDIAN macro.
> 
> Fixes: a7faf81d7858 ("scsi: megaraid_sas: Set no_write_same only for Virtual Disk")
> Cc: <stable@vger.kernel.org> # v5.6+
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas.h        | 4 ++--
>   drivers/scsi/megaraid/megaraid_sas_fusion.h | 6 +++---
>   2 files changed, 5 insertions(+), 5 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
