Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23E8C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:52:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8370123609
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 23:52:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727939AbhAGXwD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 18:52:03 -0500
Received: from mx2.suse.de ([195.135.220.15]:45758 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbhAGXwD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 18:52:03 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610063477; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=4Lzpk52chMndHm6M4qNIyv+lBh7gGNF0n27dA30CmTE=;
        b=dDMmtnjWqLiDw6P1Vu0mBa6E9E7a5FaUOAluwZtnrB/dKtrQAqDICzAbHVaXtdq+EHe0LT
        4GDFtZeWD6N0vjwHkuQIHmYVJIN4SSgP30I8vpuv94u5Tcxd6ZQtTtlmHeqKrT+W+SWzQj
        gUb+3pOisXrZ78LR8J4d9XMn1DLoF4o=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 83862AD12;
        Thu,  7 Jan 2021 23:51:17 +0000 (UTC)
Message-ID: <311d52a144ca013366cee077774aceeeac5c56eb.camel@suse.com>
Subject: Re: [PATCH V3 16/25] smartpqi: convert snprintf to scnprintf
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 00:51:16 +0100
In-Reply-To: <160763255345.26927.17474892658811246984.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763255345.26927.17474892658811246984.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> The entire Linux kernel has been slowly migrating from snprintf
> to scnprintf, so we are doing our part. This article explains
> the rationale for this change:
>     https: //lwn.net/Articles/69419/
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

AFAICS, none of the changed snprintf() invocations could possibly
overflow their target buffers, so this isn't necessary. Anyway, 

Reviewed-by: Martin Wilck <mwilck@suse.com>


