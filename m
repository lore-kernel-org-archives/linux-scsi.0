Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43C4DC4321E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:41:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C7F86127A
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 17:41:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhIORmY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Sep 2021 13:42:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:34920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230328AbhIORmX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 15 Sep 2021 13:42:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 977B36103C;
        Wed, 15 Sep 2021 17:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631727664;
        bh=zqcYWzV521X4ykcbBbUub+Ww9ntQn8wZ69cuBJqbW04=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FUm9vzoiJ92wD0Bnm/JlgPEFvDMU13oZ/aOzsAXyfRvFNozWtOmZ2SC6Vgq3x/srn
         5woB97JXInFeM3wAKylYp7L0QBM1czjfypbykKTauklp0PLr5bGNCEoV4DjoRxAFac
         I4hMGYlRF4j4oeavDw6nmPqOBNAZagqlejRtv7DFecQE2CAH6RoXkdzzeKm2NpDLCO
         HeisAr0sw5u1RbufvY/BCHqDemo6H+HlFM9OfGfbde9mt8b5/Y9IrJdjGTTAjjNAes
         7Ddcc6hvIN2EXvhtRHYa1bQdViasA01FSu7RMNey8FSpCLJkmMU5vTOWxJSMobXNsS
         c2fFBFy1yJe4g==
Date:   Wed, 15 Sep 2021 10:40:53 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org, dm-devel@redhat.com,
        Satya Tangirala <satyaprateek2357@gmail.com>
Subject: Re: [PATCH 3/5] blk-crypto: rename keyslot-manager files to
 blk-crypto-profile
Message-ID: <YUIwJQT9CnIoT7WO@sol.localdomain>
References: <20210913013135.102404-1-ebiggers@kernel.org>
 <20210913013135.102404-4-ebiggers@kernel.org>
 <YUGkfDmGa3WKz8cD@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUGkfDmGa3WKz8cD@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 15, 2021 at 08:45:00AM +0100, Christoph Hellwig wrote:
> Looks good:
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 
> It would be nice to keep the blk-crypto* includes together, though.

I don't see any case in which they aren't together.  Unless you're talking about
blk-crypto-internal.h, which is a directory-local header so it doesn't get
grouped with the <linux/*.h> headers.

- Eric
