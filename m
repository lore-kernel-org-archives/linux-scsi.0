Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C587AC433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:56:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9A8E064F26
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbhCQI4N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:56:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:33170 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229554AbhCQI4C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Mar 2021 04:56:02 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 6F2AFAC1F;
        Wed, 17 Mar 2021 08:56:01 +0000 (UTC)
Date:   Wed, 17 Mar 2021 09:56:00 +0100
From:   Daniel Wagner <dwagner@suse.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Quinn Tran <qutran@marvell.com>,
        Mike Christie <michael.christie@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH 1/7] Revert "qla2xxx: Make sure that aborted commands are
 freed"
Message-ID: <20210317085600.kqcj22ui2ffk2gfv@beryllium.lan>
References: <20210316035655.2835-1-bvanassche@acm.org>
 <20210316035655.2835-2-bvanassche@acm.org>
 <20210316082529.h3veoudiptaxcdwg@beryllium.lan>
 <13f744a1-8c91-1c33-d53b-06f2b7ccecb9@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13f744a1-8c91-1c33-d53b-06f2b7ccecb9@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Tue, Mar 16, 2021 at 01:36:34PM -0700, Bart Van Assche wrote:
> Commit 0dcec41acb85 was the result of source reading. The changes made
> by this patch in qlt_xmit_response() are wrong and may lead to a kernel
> crash. Since triggering the other code paths that are modified by that
> patch, I'd like to revert that patch in its entirety.

Thanks for the explanation. I was hoping that you have a fix for
something I see in our customer bug reports :)

Reviewed-by: Daniel Wagner <dwagner@suse.de>
