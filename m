Return-Path: <SRS0=csMy=AX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46356C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 17:40:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28F3E2070B
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jul 2020 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1594575607;
	bh=j81XFCc7+65cO2feCABXAVRBTsguNQfr1fhvqG91BGc=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=X2rvyIzqFtyynf6yoUhk4bYHKE6Pz4ntHNSTxdUOc36lRn60ddcXmdSkAloEB5j4I
	 8GJaPcIaQ0J35sLtnDI/nWf+31YMxZLLm7DzG4jFLErneWalIFi0L1bWQs2c7zIpuO
	 GYW7VqCgkzdRZynSQ/A8fM2oiGLmlyYP0aR6w9zA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729322AbgGLRkD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jul 2020 13:40:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:40904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729213AbgGLRkD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Jul 2020 13:40:03 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.8-rc4
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594575603;
        bh=j81XFCc7+65cO2feCABXAVRBTsguNQfr1fhvqG91BGc=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Jj9qLctsWOotC+HaPA+iwhpn8cMPLkkSPt099JfBxRNjMZX3D0iL0tfDvq2IlArwM
         HjPnPEqVASA+HcJG81bc6sm+dqy4m11PbQmcdkdP/m0y2hdn6iZO068h94wIdxYlGU
         hL4dCc3SKKg5n9VghoM4cdG2lS+bx0eHYq8NhyIA=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1594495523.8494.5.camel@HansenPartnership.com>
References: <1594495523.8494.5.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1594495523.8494.5.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: e094fd346021b820f37188aaa6b502c7490ab5b5
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 9599e9e7e3ee3a5afcdf00b05d4e86d256a98ae3
Message-Id: <159457560314.22698.6084914334718791002.pr-tracker-bot@kernel.org>
Date:   Sun, 12 Jul 2020 17:40:03 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 11 Jul 2020 12:25:23 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/9599e9e7e3ee3a5afcdf00b05d4e86d256a98ae3

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
