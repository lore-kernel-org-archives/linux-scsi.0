Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D5AC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 01:49:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6A7461008
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 01:49:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232568AbhDTBuV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 21:50:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbhDTBuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 21:50:20 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC20C06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 18:49:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8qSzVJuZ4iD/rH63XKxKtAtElgk52eXKXbtwiSbGluM=; b=k2NWxaMZ3QWWxdFbgyGDBSZC1a
        I507+bOCkX1cmToGMYNfqGuFGxNc2xO6NAgoPN6JqMgwyxsba8uFNIiHapZUSfe7xcxl/SwiYTUj2
        rV6ryR+6cQFbWEEqx+wTgjf2ZUlwy60rp3rWxAzWXi7eN5/uanFqCJWeqHd+9W39mXca0xrtiMKZr
        czBMiHdTTb2Xmy5I/1QGrqQVX/ror6eq5wJQyzRmtfsZpNJO0yOpLu7+qRiYKZ74VVeziopRKeSfW
        vpHWRfont9NK2Q8h76r/TsOOjYWgI8bk5oloQJJ/6Li8yiKjMv4WWqhadkb0YPWDlkxjCA9wAsV4r
        Kj0A+G+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYfVt-00EZhz-Gp; Tue, 20 Apr 2021 01:49:24 +0000
Date:   Tue, 20 Apr 2021 02:49:17 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
Message-ID: <20210420014917.GH2531743@casper.infradead.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210420000845.25873-28-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 05:07:15PM -0700, Bart Van Assche wrote:
> An explanation of the purpose of this patch is available in the patch
> "scsi: Introduce the scsi_status union".

That is not the correct way to write a changelog.
