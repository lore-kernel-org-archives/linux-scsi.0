Return-Path: <SRS0=qHo0=X6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F2FC4740A
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 20:05:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59E4E222C8
	for <linux-scsi@archiver.kernel.org>; Sat,  5 Oct 2019 20:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1570305936;
	bh=oxbOdxHcUxUWx2zWBS7kJctmNnM1ALr/0CzL2DSyvXA=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=cW4P2wgxm8kK8nZGLnyyM915AUur1GpSTZ+WYiRXch2XpWm4JL197Y0BJhGLF6uWu
	 XDWa54rOMgG6liAG+9lXWQRJeFZ/B0ZNpIBPpcEr8wlRoLgXHmPvMgc8CJhjNrxkUn
	 Q1SuFfJ25DrLlGKBnEqbhZh4cYlq0evZRGaKXL1o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730591AbfJEUF0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 5 Oct 2019 16:05:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:53516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730076AbfJEUFO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 5 Oct 2019 16:05:14 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.4-rc1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570305914;
        bh=oxbOdxHcUxUWx2zWBS7kJctmNnM1ALr/0CzL2DSyvXA=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=ilxxug3D2QqMpb7RSaMo5L1a9wkatmR3UVqXdXGcB+ab5l7qp2V/gl2z22kc4mIkT
         Y1frKeTvMTatZ0sB43OeXNQDa8S7aHm9F7J14nJL7WSk+MR08zv8ziBurprDOBlaQo
         hSM3+WOIIT6Y5W8lLoD4P0ZMpnjvCpse0C0Hdl6k=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1570250655.17537.18.camel@HansenPartnership.com>
References: <1570250655.17537.18.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1570250655.17537.18.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 0aabb6b699f72dca96988d3f428e222f932dc889
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 126195c972a2adba8cae12a65cdee155440a4525
Message-Id: <157030591442.15791.1282877858778600053.pr-tracker-bot@kernel.org>
Date:   Sat, 05 Oct 2019 20:05:14 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 04 Oct 2019 21:44:15 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/126195c972a2adba8cae12a65cdee155440a4525

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
