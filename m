Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D00FC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 09:21:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3343E6141F
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Apr 2021 09:21:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbhD1JWB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Apr 2021 05:22:01 -0400
Received: from mx2.suse.de ([195.135.220.15]:36896 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230113AbhD1JV7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Apr 2021 05:21:59 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EE6C9B000;
        Wed, 28 Apr 2021 09:21:13 +0000 (UTC)
Subject: Re: [PATCH v8 18/31] elx: efct: Driver initialization routines
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     Ram Vegesna <ram.vegesna@broadcom.com>,
        Daniel Wagner <dwagner@suse.de>
References: <20210423233455.27243-1-jsmart2021@gmail.com>
 <20210423233455.27243-19-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <20319706-5a8a-3c5b-4e8e-71ad2531e861@suse.de>
Date:   Wed, 28 Apr 2021 11:21:13 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210423233455.27243-19-jsmart2021@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/24/21 1:34 AM, James Smart wrote:
> This patch continues the efct driver population.
> 
> This patch adds driver definitions for:
> Emulex FC Target driver init, attach and hardware setup routines.
> 
> Co-developed-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: Ram Vegesna <ram.vegesna@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> Reviewed-by: Daniel Wagner <dwagner@suse.de>
> 
> ---
> v8:
> efct_xport_detach to void, Simplified getting supported speeds routine.
> ---
>  drivers/scsi/elx/efct/efct_driver.c |  788 ++++++++++++++++++
>  drivers/scsi/elx/efct/efct_driver.h |  109 +++
>  drivers/scsi/elx/efct/efct_hw.c     | 1158 +++++++++++++++++++++++++++
>  drivers/scsi/elx/efct/efct_hw.h     |   15 +
>  drivers/scsi/elx/efct/efct_xport.c  |  509 ++++++++++++
>  drivers/scsi/elx/efct/efct_xport.h  |  186 +++++
>  6 files changed, 2765 insertions(+)
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.c
>  create mode 100644 drivers/scsi/elx/efct/efct_driver.h
>  create mode 100644 drivers/scsi/elx/efct/efct_hw.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.c
>  create mode 100644 drivers/scsi/elx/efct/efct_xport.h
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
