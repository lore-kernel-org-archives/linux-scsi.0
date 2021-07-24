Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CC3FC4338F
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 20:16:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2089160EAF
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Jul 2021 20:16:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229707AbhGXTgG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Jul 2021 15:36:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:52570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229570AbhGXTgF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jul 2021 15:36:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2E04C60E09;
        Sat, 24 Jul 2021 20:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627157797;
        bh=vba6K/cIew498zlQRqU+8uu0Y73uWdHdbqKfvD8Qaco=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=jB88ztBdChJcI06wTtyIJhEBypLeBgpAG3eTxNDmVrHY6u3LIGebV34bVc/tLV7Py
         FTGlPed5+cFI+kQfhSjBb0Ugi2Sf0ba6LXs7T6PQsD277wDGQHKhHP/aZQFEMBitBk
         tbxRt/hbu9DGM4Syz45PO3chyn2tMdSXgrIN2V4QHU+oXsnJ1z6rMIrbdscc0zOtzJ
         mjRwzRyHY+uJImx3uSDjRsdTTyWVabUrPTseLj+/P9GDHCGGfz6E2pOF1+en89WQ7v
         I53iJFDUdYTYQIBS82D1G9n/Pl6ccAI6O/wBn7IoaEwSPgA2LoMZuIhLxRdW53vmhi
         DxUIMzR31j7Ug==
Subject: Re: [GIT PULL] SCSI fixes for 5.14-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <f3170ad9241f47278fa2bcb8c2e95a7e1b7dba68.camel@HansenPartnership.com>
References: <f3170ad9241f47278fa2bcb8c2e95a7e1b7dba68.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <f3170ad9241f47278fa2bcb8c2e95a7e1b7dba68.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: a47fa41381a09e5997afd762664db4f5f6657e03
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7ffca2bb9d8bf6813db50364b1dd2c02f58fb65e
Message-Id: <162715779713.1145.10797501719117113123.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Jul 2021 20:16:37 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 24 Jul 2021 10:19:38 -0700:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7ffca2bb9d8bf6813db50364b1dd2c02f58fb65e

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
