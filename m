Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DFB0C432BE
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 18:47:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7480D60C3F
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Aug 2021 18:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhH1Srv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Aug 2021 14:47:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhH1Sru (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 28 Aug 2021 14:47:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 797C360C3F;
        Sat, 28 Aug 2021 18:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630176419;
        bh=9ZYvRmk9jSTxEvunwFqVLA1g6R838quWfEF5cJAQHBc=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=esDcDKmfU3rR20Aza2yrrgwtVwPdJ5Kzlrelmqh6cTQKfHL+44CMyzV/0QlT31gNx
         XRq3BA7JbRYKHRQ64zaflcHLq2iw0VjiuBz9jl9T8934RZ2M8dsmVjWMs5WEHXA2WC
         MpkxPA7dh20toL5CxqRrRQxdmxwS+jYTzjFXYmuzUmTaWD4+ElqBZ1CTJ5Qvkvt7N+
         aBW9Ncgku0nXEiSLuDPgbyj23Cs4dIeu/6JAxMS6FTshl4kmAm5tE9r6ojJMQV4Hgp
         3kFVAwOWKfn8TAc/X88RkEDtX94k62XPpYBvi4LPvfESNvFCAd4w4ZBtdbQ54Uw9vR
         fCQ+TQG1wWWNg==
Subject: Re: [GIT PULL] SCSI fixes for 5.14-rc7
From:   pr-tracker-bot@kernel.org
In-Reply-To: <4313aa33c50578e6b3c52437d27704f24e27ae8f.camel@HansenPartnership.com>
References: <4313aa33c50578e6b3c52437d27704f24e27ae8f.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <4313aa33c50578e6b3c52437d27704f24e27ae8f.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 02c6dcd543f8f051973ee18bfbc4dc3bd595c558
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 3f5ad13cb012939e1797ec9cdf43941c169216d2
Message-Id: <163017641936.5058.110294646524611487.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Aug 2021 18:46:59 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 28 Aug 2021 11:09:55 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/3f5ad13cb012939e1797ec9cdf43941c169216d2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
