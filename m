Return-Path: <SRS0=cDh3=35=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E5A7C35254
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 01:30:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 099A8227BF
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Feb 2020 01:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581211831;
	bh=b7vBT9asDr4BsLpdUim/Gp1ihdxpO2V3HbaZUMHOYKY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=c7GntvyIFK59bpnZAa5RRcQiLiG+BkMP5mR0/rkyBEl9PzUTIeco8697+qDzao/q2
	 wek/y7mc0AHC8W/UWdjZbeu6mmckV26l7kjjk91gOwGf4fxCtEF617jG/vUSqa+YKy
	 uT5nCbGpOnx9jnNwBH43gZ2LJOenvz7fU46HXGes=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbgBIBaY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Feb 2020 20:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:36204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726474AbgBIBaY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 8 Feb 2020 20:30:24 -0500
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.5+ merge window
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581211823;
        bh=b7vBT9asDr4BsLpdUim/Gp1ihdxpO2V3HbaZUMHOYKY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=xsPy/8rJbmCLRsbLGaQV/3SWEYAkN6nZwGv6/ccwuHU3Fg68oqaj9km6Og8bIjjrq
         4PobTwU7Xass7Lg5arxcTXjmA6gH5h0RIVSUFfLEng1mGR6dY1SfYI5UAJUcdMEzxV
         JhofeqGt634kmOQpqZvyaEl6+14kGvhMd+mA8qK8=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1581190772.31918.4.camel@HansenPartnership.com>
References: <1581190772.31918.4.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1581190772.31918.4.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: e0a514259378718e0deea1def03b7025a0daaf42
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fdfa3a6778b194974df77b384cc71eb2e503639a
Message-Id: <158121182343.19605.12872491706966217069.pr-tracker-bot@kernel.org>
Date:   Sun, 09 Feb 2020 01:30:23 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 08 Feb 2020 11:39:32 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fdfa3a6778b194974df77b384cc71eb2e503639a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
