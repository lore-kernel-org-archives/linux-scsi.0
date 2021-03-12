Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 861CBC433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:28:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A4C364F9E
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:28:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbhCLQ2M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:28:12 -0500
Received: from verein.lst.de ([213.95.11.211]:46223 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232603AbhCLQ1o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 11:27:44 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0776B68B02; Fri, 12 Mar 2021 17:27:42 +0100 (CET)
Date:   Fri, 12 Mar 2021 17:27:41 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Christoph Hellwig <hch@lst.de>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 23/30] scsi: initio: Remove unused variable 'prev'
Message-ID: <20210312162741.GA11341@lst.de>
References: <20210312094738.2207817-1-lee.jones@linaro.org> <20210312094738.2207817-24-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312094738.2207817-24-lee.jones@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks fine,

Reviewed-by: Christoph Hellwig <hch@lst.de>
