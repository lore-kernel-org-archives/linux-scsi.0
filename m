Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82E07C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:09:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E42761077
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Oct 2021 18:09:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232025AbhJRSLo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Oct 2021 14:11:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229634AbhJRSLn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 18 Oct 2021 14:11:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6D5060F48;
        Mon, 18 Oct 2021 18:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634580572;
        bh=veYeKbj0Op2F8ufb/0SXpUQsgl7zFelxc3+p4G0jlW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VSdYkJQ12mFenmVPrnslfovfu25DzEgnoRqi+D95rqUN6/Um4NjTYzT/xfdRXQcW6
         7RtwGfQl2t4ddHkJ2pgkknEtrU7dboIKgepd0yuNWA716ou4r5Smsnf+pen4Bj9ljj
         EjCFYP1OYEwUgT5NNGG0WbkYg9WGXCOcbQxjJ9Ya1afF/kDbhk4vRMLwNfbXpDtJxt
         eYE8tiQhkeOedQYspQXmoRvGru4L4/JB7rJYh/7uCRQ3kub6OjpKdmcAwo/1K1i3wr
         +Lb9eKekKIHKb+/R0QBEKCG/3xN9BcTHjn5CkIUBZX0frzkZDxeWzU6a4+LINtHXeO
         mQIS6cMU2T2Vw==
Date:   Mon, 18 Oct 2021 11:09:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        dm-devel@redhat.com, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 0/4] blk-crypto cleanups
Message-ID: <YW24UuB8dLWwl9ni@sol.localdomain>
References: <20211018180453.40441-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211018180453.40441-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 18, 2021 at 11:04:49AM -0700, Eric Biggers wrote:
> 
> This series applies to block/for-next.
> 
> Changed v5 => v6:
>   - Rebased onto block/for-next yet again
>   - Added more Reviewed-by tags
> 
> Changed v4 => v5:
>   - Rebased onto block/for-next again
>   - Added Reviewed-by tags
> 
> Changed v3 => v4:
>   - Rebased onto block/for-next to resolve a conflict due to
>     'struct request' being moved.

Jens, I keep having to rebase this patchset.  Is there anything else you're
waiting for before applying it for 5.16?  Thanks!

- Eric
