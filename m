Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6118AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 18:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3B8A360FBF
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 18:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235754AbhI0SKp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 14:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235819AbhI0SKo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Sep 2021 14:10:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7A31960F12;
        Mon, 27 Sep 2021 18:09:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632766146;
        bh=GC5ye3DMcdevgzwVH8HpW+lPWBJ43B4BEoVJvD9E3Ks=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sQxpOJ8EoLraG6fxjkpXjuQf41zWRyyO4h6WuxqEWtgRf2HQ7V0xeQSNIAB9CPgTs
         LTXd4v34duK+ZCrI1TWGq4y1SibNgHRgz0+j3XJaHlch/y9Y40Fj32wS/3XfgObQmB
         3EWxKXf+aTV1e+yIOSmssUrrbtxCbDWegpMZxXpi2ppMjZef/HXTe61J5bqbGsP3vq
         2asot8SrxojuYr/JbVa3TTaEfrJndUt5DjweVpYgREWGL4hGu9GnKUE7Vuf2vqZNMF
         MxNHMd62kzXk3W7PvS3nPVIlqfMGKYA+P1ZTa6utsCKzvHnkq3IZUOkLNZf4i8YI19
         P8HaDzrMAGvzQ==
Date:   Mon, 27 Sep 2021 11:09:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Satya Tangirala <satyaprateek2357@gmail.com>, dm-devel@redhat.com,
        linux-mmc@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 0/4] blk-crypto cleanups
Message-ID: <YVIIwUv9Vwd2dFt8@gmail.com>
References: <20210923185629.54823-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210923185629.54823-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 23, 2021 at 11:56:25AM -0700, Eric Biggers wrote:
> This series renames struct blk_keyslot_manager to struct
> blk_crypto_profile, as it is misnamed; it doesn't always manage
> keyslots.  It's much more logical to think of it as the
> "blk-crypto profile" of a device, similar to blk_integrity_profile.
> 
> This series also improves the inline-encryption.rst documentation file,
> and cleans up blk-crypto-fallback a bit.
> 
> This series applies to v5.15-rc2.
> 
> Changed v2 => v3:
>   - Made some minor tweaks to patches 3 and 4, mostly comments and
>     documentation.
>   - Clarified a commit message to mention no change in behavior.
>   - Added a Reviewed-by tag.
> 
> Changed v1 => v2:
>   - Fixed a build error in blk-integrity.c.
>   - Removed a mention of "ksm" from a comment.
>   - Dropped the patch "blk-crypto-fallback: consolidate static variables".
>   - Added Acked-by and Reviewed-by tags.
> 
> Eric Biggers (4):
>   blk-crypto-fallback: properly prefix function and struct names
>   blk-crypto: rename keyslot-manager files to blk-crypto-profile
>   blk-crypto: rename blk_keyslot_manager to blk_crypto_profile
>   blk-crypto: update inline encryption documentation

Any more feedback on this?  If there are any objections to the renaming of
blk_keyslot_manager to blk_crypto_profile, now is the time to speak up.

- Eric
