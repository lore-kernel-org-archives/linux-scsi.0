Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0822C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 07:14:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbiFTHOn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 03:14:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239209AbiFTHOh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 03:14:37 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6908E08E;
        Mon, 20 Jun 2022 00:14:36 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1010868AA6; Mon, 20 Jun 2022 09:14:34 +0200 (CEST)
Date:   Mon, 20 Jun 2022 09:14:33 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 04/11] block: Add PR callouts for read keys and
 reservation
Message-ID: <20220620071433.GF11418@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com> <20220603065536.5641-5-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603065536.5641-5-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 03, 2022 at 01:55:29AM -0500, Mike Christie wrote:
> Add callouts for reading keys and reservations.
> 
> Note: This only initially adds the struct definitions in the kernel as I'm
> not sure if we wanted to export the interface to userspace yet. We may
> want to refine internally for LIO and when we can enable it for NVMe then
> add the finished interface to userspace.

Yes, this sounds like a good plan.  I can see how they would be useful
for userspace, but I'm also perfectly fine with us not locking ourselves
into an ABI quite yet.
