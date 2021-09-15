Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFA29C433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D688D61212
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 07:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhIOHih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 03:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231425AbhIOHif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Sep 2021 03:38:35 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FBDDC061574;
        Wed, 15 Sep 2021 00:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=pUaL19DkeYFLqRM9URcV8jyxtxYjsVeOkmVLQNJbRrk=; b=ihfsfrLZuiaGENTkOLmlf0pu3G
        ieODvMD4Xz4v1Tu0pjK5QEi8VmG8NIEW0vgI15iCsyBoIFGltxE/Z7HjhLNBCZWQy6mRAsiibA3/P
        dS+/nAMRJM9sLWnLejBWIwhgpiaGQ1m1M4R2/gkCU8ktqKbxXwyVyZNIElb2E0VRRvTVpFbZS6VTE
        dc/mQBGxAm7u10gRJwZfVQezFbZDaz/9cIQuODMqErEv0fZaei6SovzxyeaU32hPf5VVSz4ACBFUw
        gZhYTdEjis2gMCMh5AMHdsaRCwxs44FM8dcqBX+knDL+KUKZJmn7/xnYGv1Gr5Ztat7hihQSqvyKW
        UTFCalww==;
Received: from hch by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mQPTH-00FSyn-VW; Wed, 15 Sep 2021 07:36:54 +0000
Date:   Wed, 15 Sep 2021 08:36:43 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 1/5] blk-crypto-fallback: properly prefix function and
 struct names
Message-ID: <YUGiix18+ZvKaTe3@infradead.org>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913013135.102404-2-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Sep 12, 2021 at 06:31:31PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> For clarity, avoid using just the "blk_crypto_" prefix for functions and
> structs that are specific to blk-crypto-fallback.  Instead, use
> "blk_crypto_fallback_".  Some places already did this, but others
> didn't.
> 
> This is also a prerequisite for using "struct blk_crypto_keyslot" to
> mean a generic blk-crypto keyslot (which is what it sounds like).
> Rename the fallback one to "struct blk_crypto_fallback_keyslot".
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

These names are pretty long, but given that there aren't all the many
of them:

Reviewed-by: Christoph Hellwig <hch@lst.de>
