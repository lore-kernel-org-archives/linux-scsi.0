Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EAF8C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:59:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 196022076C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:59:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="Qpb0Yeqm";
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="oFVXsMGH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbgHLU7g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:59:36 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:60198 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726030AbgHLU7g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 16:59:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id F07128EE1DD;
        Wed, 12 Aug 2020 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597265976;
        bh=h4YzGSszXeQbBlfJMeRgGO4TecYOwdgHlVfmb2bZH74=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Qpb0Yeqm5b1HbEzAj1cPsDU6uI+/K0ca08j9Fv3XCuSa1OUmlQP+mG77kPjVj3rhb
         ANpzQNN1iWdlSiAh4v2LB4gvdADUAyRXDcbYgnBvQpe/13xpT3N+LRlaEKF8dO7ebF
         MXd3KbZqYEmOYvKAtT06WZxhJh9So1PW0v3nsN6o=
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id On9qWzP5aks6; Wed, 12 Aug 2020 13:59:35 -0700 (PDT)
Received: from [153.66.254.174] (c-73-35-198-56.hsd1.wa.comcast.net [73.35.198.56])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 6D0078EE0C7;
        Wed, 12 Aug 2020 13:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=hansenpartnership.com;
        s=20151216; t=1597265975;
        bh=h4YzGSszXeQbBlfJMeRgGO4TecYOwdgHlVfmb2bZH74=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=oFVXsMGH23dsf1Zko0UzEwuMJ/uGKUE+50mrU16zhZ86hnsD9JabJmokxjmC2ZTRU
         QD29C3OT7yiIQTH/0AsDiDBOlk+RbEG+MTvuzBT4169QG1+WX9Ewumtc7t0wTLZRBb
         neSPapb5dH1nUkMkSmluCm2QNjSvWGtxFV99629U=
Message-ID: <1597265973.7293.50.camel@HansenPartnership.com>
Subject: Re: [PATCH 1/3 for-next] pvscsi: Use coherent memory instead of dma
 mapping sg lists
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Jim Gill <jgill@vmware.com>, pv-drivers@vmware.com
Cc:     jejb@linux.ibj.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Date:   Wed, 12 Aug 2020 13:59:33 -0700
In-Reply-To: <20200812205404.GA17846@petr-dev3.eng.vmware.com>
References: <20200812205404.GA17846@petr-dev3.eng.vmware.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This is not the correct format for sending on behalf of someone else.

First there needs to be a from at the beginning separated by a blank
line identifying the Author:

From: Thomas Hellstrom <thellstrom@vmware.com>

On Wed, 2020-08-12 at 13:54 -0700, Jim Gill wrote:
> Use coherent memory instead of dma mapping sg lists each
> time they are used. This becomes important with SEV/swiotlb where
> dma mapping otherwise implies bouncing of the data. It also gets rid
> of a point of potential failure.
> 
> Tested using a "bonnie++" run on an 8GB pvscsi disk on a
> swiotlb=force
> booted kernel.
> 
> Signed-off-by: Thomas Hellstrom <thellstrom@vmware.com>
> [jgill@vmware.com: forwarding patch on behalf of thellstrom]

Then we don't need this because the From: at the beginning both
preserves the author information and makes it obvious

> Acked-by: jgill@vmware.com

And finally this needs to be a Signed-off-by: to comply with the DCO
section (c).

James

