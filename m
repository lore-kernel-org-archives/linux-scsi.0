Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7615CC433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 368E861360
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 03:24:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhDTDYf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 23:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhDTDYd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 23:24:33 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22E67C06174A
        for <linux-scsi@vger.kernel.org>; Mon, 19 Apr 2021 20:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=B+N6hPvu1B1olNk3YRK1DudGjHRi6Zxy5mMbhLKsJ6U=; b=MKWPTMVilSCxz3kt29+EQPtZAS
        OLmapswolgex8miyfLsciwW8WduaweIcEr0iWCbBT4q8cYF9xOwAtgZlZl+nsXitI5oBjF2Gn0k77
        RUoEdoJNHS17AjlofVHUJyehlGAmveGlypVmjVlbWU6VCCw93qJXsAXGZs0ANuJMixCq/Gsls0USP
        vhE/3Nd25chY9LO8QaH8Ckqi6hGhaS1yEnOJazJWhjIjCZMeCf9U8zuvHsyd5jpK4WMRzL4PS+BMB
        L8LmLa3wJYXYHW6zypvCJKcmxKSl9MPei4Ecx8eiAtyCcS66EhEyAviihYeKBE/tvcBUT3N7x/JsI
        psOnevAw==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lYgyx-00Eepw-7y; Tue, 20 Apr 2021 03:23:28 +0000
Date:   Tue, 20 Apr 2021 04:23:23 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 027/117] advansys: Convert to the scsi_status union
Message-ID: <20210420032323.GJ2531743@casper.infradead.org>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420000845.25873-28-bvanassche@acm.org>
 <20210420014917.GH2531743@casper.infradead.org>
 <eaa25d23-9d3a-0a0c-b87d-83d62ec5c46a@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eaa25d23-9d3a-0a0c-b87d-83d62ec5c46a@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 19, 2021 at 08:17:23PM -0700, Bart Van Assche wrote:
> On 4/19/21 6:49 PM, Matthew Wilcox wrote:
> > On Mon, Apr 19, 2021 at 05:07:15PM -0700, Bart Van Assche wrote:
> >> An explanation of the purpose of this patch is available in the patch
> >> "scsi: Introduce the scsi_status union".
> > 
> > That is not the correct way to write a changelog.
> 
> Thanks for having taken a look. Once there is agreement about the
> approach of this patch series I can write a script that replaces the
> above text with the description it refers to.

... I haven't taken a look.  I have no idea what this patch does,
and I can't provide feedback on the approach.  Because I haven't seen
the approach.  All I've seen is this patch, and the one to sym53c8xx.
Take a look at those patches in isolation -- would you be able to provide
any kind of sensible feedback?
