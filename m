Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F9B1C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4643C22CBE
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 11:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730168AbhALLin (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 06:38:43 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45534 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727982AbhALLil (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 06:38:41 -0500
Date:   Tue, 12 Jan 2021 12:37:56 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1610451478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaNYnLvf1TVhjRaIRbG4PoMO6ZraNHBHvAXZ6JVm1eU=;
        b=ZHaVdHnEmv7pOcHFjsuvSwhzLiUyjmpZ8+R+MmADfphr5MsL/9G84qdFiIJ8O1j26Wzc4F
        iDhV33ch4Cx0KBDlbrGdJJJ2CMrgfBbe8kORFg0k6qcWruNiyOUZG2lgUqtyxgOL9YFC3d
        NG75sCuaUF7TomH93Lu+v2ldz0AWnj0RmmmXFEsGC3hZ0gWpww8/qW1yZMEwRNdfByT/kf
        thq1hUpgw01DIaHmhL7boHNmyH5CUVwXtIEjF6MAlWAsFFcAzTL9/dCRR0yaivHvObLl22
        JiT41dBKAIAXYzpLtt0tFdGJb2pjdhneuv87ta9hDlCUS/fScG7j02Qk6k6MMw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1610451478;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BaNYnLvf1TVhjRaIRbG4PoMO6ZraNHBHvAXZ6JVm1eU=;
        b=j4knClf51uDpNKbQ8H6qWxLGsWUQiSmfhgb4BrO8rnVToDA8Td2wD+bTxmvjobYF3ExjJd
        kWOylWRF17ZlypCA==
From:   "Ahmed S. Darwish" <a.darwish@linutronix.de>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH] MAINTAINERS: Remove intel-linux-scu@intel.com for INTEL
 C600 SAS DRIVER
Message-ID: <20210112113756.GA3541178@debian-buster-darwi.lab.linutronix.de>
References: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610449890-198089-1-git-send-email-john.garry@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 12, 2021 at 07:11:30PM +0800, John Garry wrote:
> The mail address intel-linux-scu@intel.com bounces for Ahmed and I, so
> just remove it.
>
> Cc: Ahmed S. Darwish <a.darwish@linutronix.de>
> Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> Signed-off-by: John Garry <john.garry@huawei.com>
>

Acked-by: Ahmed S. Darwish <a.darwish@linutronix.de>
