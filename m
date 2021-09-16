Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0662FC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 07:43:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E054A611C8
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Sep 2021 07:43:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234847AbhIPHpH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Sep 2021 03:45:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231548AbhIPHpG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Sep 2021 03:45:06 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71679C061574;
        Thu, 16 Sep 2021 00:43:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=iB+Zk3mFqQHH5xwrFAdw0mDZFkOrBeEQEyO72oyvNCk=; b=VebekZr9eGezA0nIGfC96Vtufh
        IPgDUow8F7/VjosUcxCX7FIveg2IR8jglwoI0fUuizQ/LV2XyvMwOZ1TBNKUh41QA7boA1p8/ZXNk
        NbsdFFELMYHH5KNH8ohkM5f+Bx8vJ0huLMabfOdbyQsYBHYaCm9wcwlT3AOHq0oWJFALunIl9eUhF
        tU9dUjjK9IunqSCbM2sCJaN021EdKlhKU43EwPbjmK5ihcGeLZ8v08loUmyJaN473b7ldh9kxrtdx
        3/r19fjvCe2aLmhEbg3EbJAf3CcfWDVDXiWhDBvY2e054/5Sq5Ikm0aNNF/viKIW1zYy2XDt5XgOz
        qXNNSyCg==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQm2T-00GQXX-84; Thu, 16 Sep 2021 07:42:46 +0000
Date:   Thu, 16 Sep 2021 08:42:33 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org,
        dm-devel@redhat.com, Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 3/5] blk-crypto: rename keyslot-manager files to
 blk-crypto-profile
Message-ID: <YUL1afofaCblwRg5@infradead.org>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-4-ebiggers@kernel.org>
 <YUGkfDmGa3WKz8cD@infradead.org>
 <YUIwJQT9CnIoT7WO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUIwJQT9CnIoT7WO@sol.localdomain>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 10:40:53AM -0700, Eric Biggers wrote:
> > It would be nice to keep the blk-crypto* includes together, though.
> 
> I don't see any case in which they aren't together.  Unless you're talking about
> blk-crypto-internal.h, which is a directory-local header so it doesn't get
> grouped with the <linux/*.h> headers.

You're right.   I skimmed over the patch too quickly.
