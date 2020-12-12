Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89DFAC433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 21:04:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51F642250F
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Dec 2020 21:04:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407948AbgLLVER (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Dec 2020 16:04:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbgLLVD7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 12 Dec 2020 16:03:59 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.10-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607806999;
        bh=jswMUpTjsyCQ5hfsOANp6aigxbw0bihRVxrpVeHpWtM=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dQPejd9SpwYrlqpjuqW+SYqb8Q/goVC0+BbvMpSebv0oFBwoWbkPbevOnlloVfEnC
         6IJUGdArh3aULKa7XM2dwFnqdBtYpqCTDvgtD61y0lqkvn1orpuPeGwM5NKPXfYNgu
         55jdrQjjK0N+UGMzM1Uq3bwXmq8FrwMOALOtZQLTHNVT2FfDmXBxLQhhBG9IyA2rZG
         kHCCnwuCFYPhi48IL/gKDvrcI2ymBiircTlCRG9EuC2SHXPp4BueTMKLPOMrxYxk4m
         /xaaWfml1WnYdprTW/u83PynLAbEeCpLj8zoE6yITe2VQTaCGbPOJaLKCCkKqCa/7F
         zycfusVVvL34g==
From:   pr-tracker-bot@kernel.org
In-Reply-To: <a66d77104855fe9cec651d3c51aef288c2676dc2.camel@HansenPartnership.com>
References: <a66d77104855fe9cec651d3c51aef288c2676dc2.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <a66d77104855fe9cec651d3c51aef288c2676dc2.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 4da3a54f5a025846f9930354cfb80f075b9952e0
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6bff9bb8a292668e7da3e740394b061e5201f683
Message-Id: <160780699924.2095.628693049935910139.pr-tracker-bot@kernel.org>
Date:   Sat, 12 Dec 2020 21:03:19 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 12 Dec 2020 11:32:54 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6bff9bb8a292668e7da3e740394b061e5201f683

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
