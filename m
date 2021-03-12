Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FB81C1550C
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0431C65006
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 16:38:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232702AbhCLQhx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 11:37:53 -0500
Received: from verein.lst.de ([213.95.11.211]:46288 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232217AbhCLQhp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 12 Mar 2021 11:37:45 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id D269468B05; Fri, 12 Mar 2021 17:37:42 +0100 (CET)
Date:   Fri, 12 Mar 2021 17:37:42 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Ledford <dledford@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 24/30] scsi: a100u2w: Remove unused variable 'bios_phys'
Message-ID: <20210312163742.GA11620@lst.de>
References: <20210312094738.2207817-1-lee.jones@linaro.org> <20210312094738.2207817-25-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210312094738.2207817-25-lee.jones@linaro.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 12, 2021 at 09:47:32AM +0000, Lee Jones wrote:
> Fixes the following W=1 kernel build warning(s):

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
