Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C80D4C07E96
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 18:22:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id ACA7D610D2
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Jul 2021 18:22:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235789AbhGKSZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Jul 2021 14:25:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235781AbhGKSY5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 11 Jul 2021 14:24:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D1A4D60240;
        Sun, 11 Jul 2021 18:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626027730;
        bh=6QV5IIy4YSccpVJwf7K0V3zWheiaawRzbTuzGJZHO6I=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=bk+CD7idtuLTaFMXizgMWWtuEhRmoCFBSRVTFSv8qYnsZTiIPL5vqWBEH+N75SQoC
         FYV+vRwcFu5/5xyF+GBsU8foxf2SmXICcDELiog+bmrBKu/Jnt07kWz0OclhV4+/MV
         gPGRfBCaf9rbeDIJEFP4iDkfp/hicdrW0OiqW6zCzhpVVRqYEPLykpW+4L4mtRGkM7
         Ar9cauUJZTEBTMqK0haEH0V3/mznEJF4y+Q4RMF7TEfx5T8GI/kjxDMp/DSwhES/L6
         N70nRO3ZKiU62Tx3kdG1z+pMUbf4dgsZ5+VbfSA+8fvmmCfqVMXM+QIA05moKmqWSk
         t/t9bDtgzgWvw==
Subject: Re: [GIT PULL] final round of SCSI updates for the 5.13+ merge window
From:   pr-tracker-bot@kernel.org
In-Reply-To: <64e271620b6a9a8a12848f9fa5dc8d4c31be8123.camel@HansenPartnership.com>
References: <64e271620b6a9a8a12848f9fa5dc8d4c31be8123.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <64e271620b6a9a8a12848f9fa5dc8d4c31be8123.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc
X-PR-Tracked-Commit-Id: 5f638e5ac61ef1b9b588efdf688acc0a4cecdca2
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8b9cc17a46215af733c83bea36366419133dfa09
Message-Id: <162602773082.20558.8448928583496792144.pr-tracker-bot@kernel.org>
Date:   Sun, 11 Jul 2021 18:22:10 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sun, 11 Jul 2021 08:04:52 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-misc

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8b9cc17a46215af733c83bea36366419133dfa09

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
