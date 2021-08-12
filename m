Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8867EC4338F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 12:28:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 684496104F
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Aug 2021 12:28:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236287AbhHLM2p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Aug 2021 08:28:45 -0400
Received: from verein.lst.de ([213.95.11.211]:44176 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237469AbhHLM2p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Aug 2021 08:28:45 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 9D0FC68B05; Thu, 12 Aug 2021 14:28:18 +0200 (CEST)
Date:   Thu, 12 Aug 2021 14:28:18 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v5 01/52] core: Introduce the scsi_cmd_to_rq() function
Message-ID: <20210812122818.GD19050@lst.de>
References: <20210809230355.8186-1-bvanassche@acm.org> <20210809230355.8186-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210809230355.8186-2-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This seems to miss a cover letter and about 40 or your 52 patches.  No
idea how I am supposed to review it.
