Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCBCEC3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 12:16:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244546AbjHYMQR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Aug 2023 08:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244611AbjHYMPw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Aug 2023 08:15:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FF7AE6B;
        Fri, 25 Aug 2023 05:15:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1BC262263;
        Fri, 25 Aug 2023 12:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52634C433CD;
        Fri, 25 Aug 2023 12:15:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692965750;
        bh=hmmaKalEHmRrjbliPzu7rTUes6QoqRdIs5b3PhZ12mw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h/PuitcNvu4dx/i7MIDWMFu4egRfQD43sXTSd0WzHTvc5A+fbE8Id23tPtrFVzpbO
         s679Rjrs7kgLCEqKsIaMVafeRix4UWcdRW2WaSQJx71/aXUO0CGLQWDCb2jkYAlxpz
         Z8tfs6zDPerC9E4djq2vfxyDCLeMhllzDEy4TTN1S4KxSRqhntaQCmLSBBftDgOKQq
         sX/0sx6WNckj3TK6m1Yqm2+bwczYu41rDncBYf6X4Z3ouCf41++cfWH69XxYfZcIEE
         ktIxhbdBZm6MN1GozoF4a/beKdeX1I8PsE8jHNe9ayiJ2msb1A3k7g0X+E5Q5uE4oY
         vt7AjNL6W5jbQ==
Date:   Fri, 25 Aug 2023 14:15:45 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Jan Kara <jack@suse.cz>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH 15/29] scsi: target: Convert to bdev_open_by_path()
Message-ID: <20230825-entrollt-ausgearbeitet-850021749ef7@brauner>
References: <20230818123232.2269-1-jack@suse.cz>
 <20230823104857.11437-15-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230823104857.11437-15-jack@suse.cz>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 23, 2023 at 12:48:26PM +0200, Jan Kara wrote:
> Convert iblock and pscsi drivers to use bdev_open_by_path() and pass the
> handle around.
> 
> CC: target-devel@vger.kernel.org
> CC: linux-scsi@vger.kernel.org
> Acked-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---

Looks good to me,
Acked-by: Christian Brauner <brauner@kernel.org>
