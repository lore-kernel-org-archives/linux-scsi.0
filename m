Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1123CC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 20:10:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C74C422EBE
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 20:10:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbhAWUKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 23 Jan 2021 15:10:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:44374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726481AbhAWUGV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 23 Jan 2021 15:06:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 759CA22DBF;
        Sat, 23 Jan 2021 20:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611432341;
        bh=ufOWfX06GD/ZZlE9WQYBcsk5ibYRtNW5r0tb1ZDT+6U=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=sx0pEBy94q8Db8DM7ucQe1V3EFs9PhpgimyxfcLj0G6P0P+/R8CQs+kulYWxsvMml
         rLdB24MCKmXfjVRvPqXSw9/j09dOPMHS9jaL4tyh540XnX83t17jdnYNJW95Rjj8Sp
         25FrB33a3mypMI8dmjKJAJ1BjN+ZpYzgNPfBoon7eGZTRl+HmLvOuewPFclzee/hob
         4OxI44j3wjZz75nuvfv+yFOfkAOQI+dwv/MRYUGnqXMQYtH1K2pzkO3FxMou/mbTt7
         tyzSn33qGPWVIDlmTu+Hw2NmTV8IT2duvTIVFlukT6Ecy+0jlKqoiznTcyqV2+BBl7
         0vEacaPB03F0w==
Subject: Re: [GIT PULL] SCSI fixes for 5.11-rc4
From:   pr-tracker-bot@kernel.org
In-Reply-To: <eff0c907e53013d3d620d6b015d77244f8423dc8.camel@HansenPartnership.com>
References: <eff0c907e53013d3d620d6b015d77244f8423dc8.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <eff0c907e53013d3d620d6b015d77244f8423dc8.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 764907293edc1af7ac857389af9dc858944f53dc
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 15cfb0f06db41542ba16907a964874ea9cfe99b2
Message-Id: <161143234142.8668.3606666293845994253.pr-tracker-bot@kernel.org>
Date:   Sat, 23 Jan 2021 20:05:41 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Fri, 22 Jan 2021 18:30:49 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/15cfb0f06db41542ba16907a964874ea9cfe99b2

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
