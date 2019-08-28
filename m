Return-Path: <SRS0=d3SH=WY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C070C3A5A1
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 07:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 757B2217F5
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Aug 2019 07:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbfH1HPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Aug 2019 03:15:20 -0400
Received: from mx2.suse.de ([195.135.220.15]:59914 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726252AbfH1HPU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Aug 2019 03:15:20 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F3498AE0C;
        Wed, 28 Aug 2019 07:15:18 +0000 (UTC)
Subject: Re: [PATCH] lpfc: Remove bg debugfs buffers
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
References: <20190827212805.30060-1-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <63c35a7f-1ab7-b02d-a903-87360b905280@suse.de>
Date:   Wed, 28 Aug 2019 09:15:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190827212805.30060-1-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/27/19 11:28 PM, James Smart wrote:
> Capturing and downloading dif command data and dif data was done a
> dozen years ago and no longer being used. Also creates a potential
> security hole.
> 
> Remove the debugfs buffer for dif debugging.
> 
> Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> CC: KyleMahlkuch <kmahlkuc@linux.vnet.ibm.com>
> CC: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/lpfc/lpfc.h         |   2 -
>   drivers/scsi/lpfc/lpfc_crtn.h    |  10 ---
>   drivers/scsi/lpfc/lpfc_debugfs.c | 134 ---------------------------------------
>   drivers/scsi/lpfc/lpfc_init.c    |  70 --------------------
>   drivers/scsi/lpfc/lpfc_scsi.c    |  79 -----------------------
>   5 files changed, 295 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                              +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Mary Higgins, Sri Rasiah
HRB 21284 (AG Nürnberg)
