Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA11C636C9
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Jul 2021 20:13:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1807C610CB
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Jul 2021 20:13:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235379AbhGQUQe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Jul 2021 16:16:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234719AbhGQUQe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 17 Jul 2021 16:16:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5C04361073;
        Sat, 17 Jul 2021 20:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626552817;
        bh=R5V5R0C9S92oh4qIP/pHfW6NP+H2PzTvT66oEP3UeH0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=REFkvchDtSec1YiW/PUUqTn9cliQNpmcQ3VTdBMfwvTqwhB5GAzEBzM0JOSdwteVb
         AQfHAqAWyCW6nQatDFiu6/AFNmYh4NZtW72RAoqFt//M2QwvJzlknegejL7clWJ4x3
         t5xXGtzkSqZd1n9ReGVZ7j0qayPoxBXuHixgcQaWU24rd13Unr2v4Wa3zn9YqX8/57
         KlmEv+mgnBRVdrVFjDZVrtosQTCXT/TK4ceZek1+5+mfaw8X+qwx2zPRd4KXIaFMlb
         MoO849y3/ZcMAfYaS/3lD/2ks7lrTa4ihaFnDzgiojjfqlabYMvX15HR4sJheVAruo
         KoLJfAO/iSnGg==
Subject: Re: [GIT PULL] SCSI fixes for 5.14-rc1
From:   pr-tracker-bot@kernel.org
In-Reply-To: <57d614d67af1c091c40a520bb8e2dca27e08833e.camel@HansenPartnership.com>
References: <57d614d67af1c091c40a520bb8e2dca27e08833e.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <57d614d67af1c091c40a520bb8e2dca27e08833e.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 053c16ac89050ef0e8ab9dc1edaf157bf104c8c6
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 5d766d55d163a60b709317b15db6c8bb02bf54e4
Message-Id: <162655281732.27873.12042789984497413675.pr-tracker-bot@kernel.org>
Date:   Sat, 17 Jul 2021 20:13:37 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 17 Jul 2021 07:38:43 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/5d766d55d163a60b709317b15db6c8bb02bf54e4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
