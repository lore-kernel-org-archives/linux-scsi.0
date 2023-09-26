Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62766E7E637
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 14:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229520AbjIZOHK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 10:07:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229958AbjIZOHI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 10:07:08 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF44116;
        Tue, 26 Sep 2023 07:07:01 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF132C433C7;
        Tue, 26 Sep 2023 14:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695737221;
        bh=OAf49Bdt77gbFnwJyhomb+AoFJ28mqepEZFPzWrA/fc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nw3+BPuYbgdNd3e0V/nwSaYrXyej6Z01Hn1Nt2Sv4UeTdc+Bl+rqAb2bZIJMjqJL5
         Ep02JsAByoKT3vc0BxH9InkJYYVlHTe5u3xqnxXBV2Pa8OfzUq6obUi3rpIm9pr/SX
         b4PTd+c4XKtfa5CrGjvn1xyAZFP0/wR9kXTXRnw3UU6Y89BYbsFzgajywpJjbPrOC7
         WTMsEDCG8pEkiwTN5ZxW7p5sDOhkHNo6NcxxZ/kzc6wJgD8gx65Fxaps7rzVX2Tda1
         rZHjpSEh5wcV77akFqZmp1IFAgyStRasB4ir5EXIa5Hg0fSpeA6YDYv0ZpLiQCB2+d
         cnuY3+7wxG5sQ==
Date:   Tue, 26 Sep 2023 17:06:56 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     zyjzyj2000@gmail.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org,
        rpearsonhpe@gmail.com, matsuda-daisuke@fujitsu.com,
        bvanassche@acm.org, shinichiro.kawasaki@wdc.com,
        linux-scsi@vger.kernel.org, Zhu Yanjun <yanjun.zhu@intel.com>
Cc:     Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH 1/1] Revert "RDMA/rxe: Add workqueue support for rxe
 tasks"
Message-ID: <20230926140656.GM1642130@unreal>
References: <20230922163231.2237811-1-yanjun.zhu@intel.com>
 <169572143704.2702191.3921040309512111011.b4-ty@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <169572143704.2702191.3921040309512111011.b4-ty@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 26, 2023 at 12:43:57PM +0300, Leon Romanovsky wrote:
> 
> On Fri, 22 Sep 2023 12:32:31 -0400, Zhu Yanjun wrote:
> > This reverts commit 9b4b7c1f9f54120940e243251e2b1407767b3381.
> > 
> > This commit replaces tasklet with workqueue. But this results
> > in occasionally pocess hang at the blktests test case srp/002.
> > After the discussion in the link[1], this commit is reverted.
> > 
> > 
> > [...]
> 
> Applied, thanks!
> 
> [1/1] Revert "RDMA/rxe: Add workqueue support for rxe tasks"
>       https://git.kernel.org/rdma/rdma/c/e710c390a8f860

I applied this patch, but will delay it for some time with a hope that
fix will arrive in the near future.

Thanks

> 
> Best regards,
> -- 
> Leon Romanovsky <leon@kernel.org>
> 
