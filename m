Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C5F0EC43217
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 17:28:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B3AC760E9C
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 17:28:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbhKARb2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:53470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229541AbhKARb0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Nov 2021 13:31:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C9C5F60ED5;
        Mon,  1 Nov 2021 17:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635787732;
        bh=ltpFxnB+g8AK8uV4bpIVUPm5lviQ2I3+KFNpCyEumjo=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jgdgbEr16n6yR+MGQBpOxgOAznZXBq3znfDcQy0dEunPIKP7f0QZ+01AnFIUWcloO
         BPfx0fz45hOZraQ0yH2jY3axz7Aprz5j7YRN80syUTbkzlIPMAmATJIuLDnOsc5D8M
         tFuW/2vdtlE87Wsj7qcuhbKd9qaEKBlL8HX57XQlT6zJKZqHLpsYoo95zS90Ook9P1
         gE8XRJvpIse3N5jplBCr2B7ILrz+G97CdK+drL4j6hdoudBONXpmyiZRlkH1AKNnq5
         ncH26JqGouohwhT3BiOegQqUuPMfXv/r2i9h+5S1J86ec/BcrDDkcQzsCKedkAgEQo
         IOhUL9F7YAUsQ==
Subject: Re: [GIT PULL] SCSI multi-actuator support
From:   pr-tracker-bot@kernel.org
In-Reply-To: <93d17044-440c-a7f6-45fe-ea804b2a0977@kernel.dk>
References: <93d17044-440c-a7f6-45fe-ea804b2a0977@kernel.dk>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <93d17044-440c-a7f6-45fe-ea804b2a0977@kernel.dk>
X-PR-Tracked-Remote: git://git.kernel.dk/linux-block.git tags/for-5.16/scsi-ma-2021-10-29
X-PR-Tracked-Commit-Id: 9d824642889823c464847342d6ff530b9eee3241
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: fcaec17b3657a4f8b0b131d5c1ab87e255c3dee6
Message-Id: <163578773279.18307.13436670741876022751.pr-tracker-bot@kernel.org>
Date:   Mon, 01 Nov 2021 17:28:52 +0000
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sun, 31 Oct 2021 13:41:58 -0600:

> git://git.kernel.dk/linux-block.git tags/for-5.16/scsi-ma-2021-10-29

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/fcaec17b3657a4f8b0b131d5c1ab87e255c3dee6

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
