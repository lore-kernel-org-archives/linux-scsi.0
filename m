Return-Path: <SRS0=+pcl=63=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECB56C2D0F8
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 06:21:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D2C3F20718
	for <linux-scsi@archiver.kernel.org>; Wed, 13 May 2020 06:21:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgEMGVD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 02:21:03 -0400
Received: from mx2.suse.de ([195.135.220.15]:35924 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgEMGVD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 13 May 2020 02:21:03 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id ECB36ABBE;
        Wed, 13 May 2020 06:21:04 +0000 (UTC)
Subject: Re: [PATCH 2/5] megaraid_sas: Remove IO buffer hole detection logic
To:     Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com
References: <20200508083838.22778-1-chandrakanth.patil@broadcom.com>
 <20200508083838.22778-3-chandrakanth.patil@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <804ec0d0-b403-4e23-1946-415f4d9c9c3a@suse.de>
Date:   Wed, 13 May 2020 08:21:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200508083838.22778-3-chandrakanth.patil@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/8/20 10:38 AM, Chandrakanth Patil wrote:
> As blk_queue_virt_boundary() API in slave_configure ensures that no IOs
> will come with holes/gaps. Hence, code logic to detect the holes/gaps in
> IO buffer is not required.
> 
> Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
> Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
> ---
>   drivers/scsi/megaraid/megaraid_sas_fusion.c | 58 -----------------------------
>   1 file changed, 58 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
