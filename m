Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40CECC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 16:46:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2259C619E3
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Oct 2021 16:46:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhJUQs5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Oct 2021 12:48:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230072AbhJUQs4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Oct 2021 12:48:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 67F4F61881;
        Thu, 21 Oct 2021 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634834800;
        bh=iC+jEvBd68MxpfS1IB/mFYo8PwGK9O5v77F9dmGpWIQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=exrtJuCA4a0RjDSm+Yy3i/2ADnH6ylY3ujQtymKhCYgLkd1rRuGhQF+sbCrFykzwN
         vixYe4s8eAM4bpEhn7wwxpWD8vC7rE2AwtgouWvLaaT/a3TuK3p6Ar6FGH/QIi0iKE
         SUGuXtAMT5DYHj2B5+cacp+tWyBTDzQMgrDIu5Ji4TvWuQqHKz8Q6VXwVKN00CF8xS
         NVfB5gw96D+j/65ZzheOWJv78mIj3GbYLcEXF1SmRkht1UC7q5NC7S7Esd4ym/4/La
         eBDVb8fyvhYmVi7boBbJhvCZQWywMaIwIClDlDCIzau3vKwlgK5i/TalR+WGyW7reB
         Bk9kCRTMhY8/g==
Date:   Thu, 21 Oct 2021 09:46:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org,
        Satya Tangirala <satyaprateek2357@gmail.com>,
        dm-devel@redhat.com, linux-mmc@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v6 0/4] blk-crypto cleanups
Message-ID: <YXGZbvTQBgtaPojY@gmail.com>
References: <20211018180453.40441-1-ebiggers@kernel.org>
 <YW24UuB8dLWwl9ni@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YW24UuB8dLWwl9ni@sol.localdomain>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 18, 2021 at 11:09:22AM -0700, Eric Biggers wrote:
> On Mon, Oct 18, 2021 at 11:04:49AM -0700, Eric Biggers wrote:
> > 
> > This series applies to block/for-next.
> > 
> > Changed v5 => v6:
> >   - Rebased onto block/for-next yet again
> >   - Added more Reviewed-by tags
> > 
> > Changed v4 => v5:
> >   - Rebased onto block/for-next again
> >   - Added Reviewed-by tags
> > 
> > Changed v3 => v4:
> >   - Rebased onto block/for-next to resolve a conflict due to
> >     'struct request' being moved.
> 
> Jens, I keep having to rebase this patchset.  Is there anything else you're
> waiting for before applying it for 5.16?  Thanks!
> 
> - Eric

Ping?
