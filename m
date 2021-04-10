Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64941C433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 20:14:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278FF61108
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 20:14:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235014AbhDJUOk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 16:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:52876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234439AbhDJUOk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 10 Apr 2021 16:14:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0444E610E5;
        Sat, 10 Apr 2021 20:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618085665;
        bh=5pnnNjLCbpDWbQhQeUcnOmgAipGds621br/DGFiC8Co=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=uHpRYHHh4lqoGzutJa1VU9hz37LaB2UJJwPnrnJxTLxMgjI44hEl5WKQeZyTsV057
         /DbkOmhHFvyKIIsGvQ/HrtoVkV2ufZ3sciRMJwfWKoiP9gIUOZ17N8eRkYAuPZ7rhq
         bjz+WKUoAHI9gnwR6t8+TVRtRd3M1LECgZ8JCmruvX4mGBYmAuhT/kTBdf5nT3JKhr
         /N4ZRs4j/lnKKw1RLotryNm1YnPO0pLTTMFAGfcjSE8ft9033FPgNbhdYOoQWy0zar
         9+A73R2GRv/Flj1gU5V2d22qGdkiBP3D4ofyIHsSVIm92SmAocM43i9Ma1wnS5fDf7
         5u9DGB5/BcEUQ==
Subject: Re: [GIT PULL] SCSI fixes for 5.12-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <dd2a3e71111fc7d1e35fa1a22de3e79adf09e26f.camel@HansenPartnership.com>
References: <dd2a3e71111fc7d1e35fa1a22de3e79adf09e26f.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <dd2a3e71111fc7d1e35fa1a22de3e79adf09e26f.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 5cd0f6f57639c5afbb36100c69281fee82c95ee7
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: efc2da9241e643cb90897ac4ed3542daa3edf3bc
Message-Id: <161808566486.10926.1662660507937419801.pr-tracker-bot@kernel.org>
Date:   Sat, 10 Apr 2021 20:14:24 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 10 Apr 2021 10:48:41 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/efc2da9241e643cb90897ac4ed3542daa3edf3bc

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
