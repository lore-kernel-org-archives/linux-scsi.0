Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03C29C4320E
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 13:36:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC07660FE6
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Sep 2021 13:36:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244255AbhIANhT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 09:37:19 -0400
Received: from verein.lst.de ([213.95.11.211]:47951 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244227AbhIANhS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 1 Sep 2021 09:37:18 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id A57EC6736F; Wed,  1 Sep 2021 15:36:18 +0200 (CEST)
Date:   Wed, 1 Sep 2021 15:36:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Abdul Haleem <abdhalee@linux.vnet.ibm.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>, hch@lst.de,
        jack@suse.cz, axboe@kernel.dk,
        linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        dm-devel@redhat.com, sachinp <sachinp@linux.vnet.ibm.com>,
        Brian King <brking@linux.vnet.ibm.com>, dougmill@us.ibm.com
Subject: Re: [next-20210827][ppc][multipathd] INFO: task hung in
 dm_table_add_target
Message-ID: <20210901133618.GA16687@lst.de>
References: <68dde454-965a-0c44-374a-a0ca277150ee@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68dde454-965a-0c44-374a-a0ca277150ee@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 01, 2021 at 04:47:26PM +0530, Abdul Haleem wrote:
> Greeting's
>
> multiple task hung while adding the vfc disk back to the multipath on my 
> powerpc box running linux-next kernel

Can you retry to reproduce this with lockdep enabled to see if there
is anything interesting holding this lock?
