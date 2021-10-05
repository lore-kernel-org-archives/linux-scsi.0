Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9399C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 17:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9C0761381
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Oct 2021 17:26:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234447AbhJER2J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Oct 2021 13:28:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233671AbhJER2J (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 5 Oct 2021 13:28:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EE6A61350;
        Tue,  5 Oct 2021 17:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633454778;
        bh=TRVVk+cqSwmsQPPrsGSixnwW56Ss0wyABclPIq4gyE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pyoR1P2drWCfoIMMWXbZbYfSVyvJ+FFcLILOhILVTcsHIzWS7FylokMYssDKCymyv
         KIjPMKiI4uqFw4QY1iuTRSlKATXzlVP6qy4TIHTip7QDbtZ0i6gNX0RzsafwUdS84C
         Mvk7JYogoERYPcVuDz/UCTwBOxQS8JAnRrQhEyq7jAdHoTm6zFXTCqcjrKhAn2Ss1L
         8rTeB+xJGsbDesPU1hTAlYm3FQZ9dE43ca/V3p3ofMC1D99wew15nHOznhpgsvVFUT
         l/v5J9seOQknAg6LBuPw3SzPjujBnzeECGRpsZ3/iIrXPXLRKEi+11+Cac7sBPs17W
         x8awmT/CeEBcg==
Date:   Tue, 5 Oct 2021 10:26:17 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v4 0/4] blk-crypto cleanups
Message-ID: <YVyKuXgDjNgNdSHS@gmail.com>
References: <20210929163600.52141-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929163600.52141-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 09:35:56AM -0700, Eric Biggers wrote:
> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the
> "blk-crypto profile" of a device, similar to blk_integrity_profile.
> 
> This series also improves the inline-encryption.rst documentation file,
> and cleans up blk-crypto-fallback a bit.
> 
> This series applies to block/for-next.
> 
> Changed v3 => v4:
>   - Rebased onto block/for-next to resolve a conflict due to
>     'struct request' being moved.
> 

Ping?

- Eric
