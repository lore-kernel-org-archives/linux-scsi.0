Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A08A7C48BCD
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 749C461181
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 06:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbhFJGWJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Jun 2021 02:22:09 -0400
Received: from smtprelay0094.hostedemail.com ([216.40.44.94]:50536 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229634AbhFJGWJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Jun 2021 02:22:09 -0400
Received: from omf12.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id 1B59E180A7FE8;
        Thu, 10 Jun 2021 06:20:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf12.hostedemail.com (Postfix) with ESMTPA id B7F8924023B;
        Thu, 10 Jun 2021 06:20:10 +0000 (UTC)
Message-ID: <f36df404d219ff11546c3244054db348538e21db.camel@perches.com>
Subject: Re: [PATCH v2] scsi: lpfc: lpfc_init: deleted these repeated words
From:   Joe Perches <joe@perches.com>
To:     lijian_8010a29@163.com, james.smart@broadcom.com,
        dick.kennedy@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        lijian <lijian@yulong.com>
Date:   Wed, 09 Jun 2021 23:20:09 -0700
In-Reply-To: <20210610060921.67172-1-lijian_8010a29@163.com>
References: <20210610060921.67172-1-lijian_8010a29@163.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspamout01
X-Rspamd-Queue-Id: B7F8924023B
X-Stat-Signature: epojie33baoucrokunpomaa1buxnjias
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX182pRNdeCXYGCw9uVtg8ofXfe97+/XR8/s=
X-HE-Tag: 1623306010-995556
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2021-06-10 at 14:09 +0800, lijian_8010a29@163.com wrote:
> From: lijian <lijian@yulong.com>
> 
> deleted these repeated words 'the', 'using' and 'be' in the comments.
> 
> Signed-off-by: lijian <lijian@yulong.com>
> ---
> v2: Fix these typos
> Change 'irrelvant' to 'irrelevant'.
> Change 'will be re-try' to 'will be retried'.

This should be part of the commit message.
The content below the --- line is not added to any git commit.
 
> diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
[]
> @@ -5894,7 +5894,7 @@ lpfc_sli4_async_fip_evt(struct lpfc_hba *phba,
>  				phba->fcf.fcf_flag &= ~FCF_ACVL_DISC;
>  				spin_unlock_irq(&phba->hbalock);
>  				/*
> -				 * Last resort will be re-try on
> +				 * Last resort will be retried on

retried on the current/to retry (with?) the current

Your spelling fixes seem reasonable but perhaps you could find a
fully fluent English speaker/writer to review your proposals before
submitting English grammar patches. 


