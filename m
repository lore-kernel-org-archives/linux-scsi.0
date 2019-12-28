Return-Path: <SRS0=EFIP=2S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22849C2D0C3
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 01:50:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E7DF520CC7
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Dec 2019 01:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1577497812;
	bh=gX2uSCF/FJcgkN9bHzL3GcCgh2erjkE5svBOCnK2A7U=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=IRRSlrgshyyDleO/areU64PlKz7rpQHYhz75NUh5IiTDStIx2ik1z1WBJiZtCFH/h
	 FiCeijJVK6n1sIYZ/V/89TImekd/IVLGVsljSsbsNcZfJhVXkl20rwHjO/K86a8Dak
	 ukwhbfmbR3D5QcXCYJXKJ7pBlc9n1VIURjn2sZ8w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726080AbfL1BuI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Dec 2019 20:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:53568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbfL1BuH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Dec 2019 20:50:07 -0500
Subject: Re: [GIT PULL] SCSI fixes for 5.5-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577497807;
        bh=gX2uSCF/FJcgkN9bHzL3GcCgh2erjkE5svBOCnK2A7U=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=PvFuaL46XiPgAGpO/eyWmvr/q2odrPd5cnsI0KAfEOzI0dcATQ1ULOiO4Fxck1Ejm
         F6ADry4EBfPe8o0wREjNUydKpQQp8eXvkQk/H7WJL58nLAGHH3Q/EBeI1tqw1TFqlK
         iUJxPT1S/0M6PtmE3RL0h7jHBiTFNPFAlQQlvFHE=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1577487428.3225.6.camel@HansenPartnership.com>
References: <1577487428.3225.6.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1577487428.3225.6.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: e4dc9a4c31fe10d1751c542702afc85be8a5c56a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: bf8d1cd4386535004c4afe7f03d37f9864c9940e
Message-Id: <157749780714.14322.9215059600125703568.pr-tracker-bot@kernel.org>
Date:   Sat, 28 Dec 2019 01:50:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 27 Dec 2019 14:57:08 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/bf8d1cd4386535004c4afe7f03d37f9864c9940e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
