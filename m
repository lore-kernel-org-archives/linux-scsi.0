Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEFEEC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 17:12:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C09B60F57
	for <linux-scsi@archiver.kernel.org>; Sun, 24 Oct 2021 17:12:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231482AbhJXROv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 24 Oct 2021 13:14:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:54988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230301AbhJXROt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 24 Oct 2021 13:14:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AD35B60F57;
        Sun, 24 Oct 2021 17:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635095548;
        bh=/lx79IiPRRgzaUDtpG2BBuaeJql6qkCdMzPGjm6VBgs=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=ho2VfM2HI9FuBGPYkN6UJuGNWuDe+8bXqcalcJXQpKerHrNlz/f4PsfOjI1ocgP8z
         SfuzwG+ahQ1YpeAX9v/WN3GjZncFMbDrNuTO4nx2QycgXXH2k7gveSRlkjcT9ZehmK
         dbDsQNiRjSytQbcKQG9I0/0fpYCPX2ftdkJ39c2tCLb8/gb2BKs9NhkmK6Fz/mNzuG
         JyRXPAP7xeT5TjauP9wy5hrdxMS02OVw4zdNY4DHDa1xVM1H7i85mtcNUuVG5HJ8hF
         V28HRM9JkndlnR2HjFyCSpeSqSx1TpY4j3w25A43ANXsTHwJc+ZgR5evfdG/0O8PpC
         Uh8LkLGa2YpMA==
Subject: Re: [GIT PULL] SCSI fixes for 5.15-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <14c6e40fec98dbd042c37ea6f65cbd0617b79d78.camel@HansenPartnership.com>
References: <14c6e40fec98dbd042c37ea6f65cbd0617b79d78.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-scsi.vger.kernel.org>
X-PR-Tracked-Message-Id: <14c6e40fec98dbd042c37ea6f65cbd0617b79d78.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 4e5483b8440d01f6851a1388801088a6e0da0b56
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 0f386a604ce5074724909a8927d6d97ef998b5a9
Message-Id: <163509554867.13231.3363722534556274032.pr-tracker-bot@kernel.org>
Date:   Sun, 24 Oct 2021 17:12:28 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 23 Oct 2021 12:10:42 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/0f386a604ce5074724909a8927d6d97ef998b5a9

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
