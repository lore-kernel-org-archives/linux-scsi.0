Return-Path: <SRS0=/6u/=WU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96B86C3A59E
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5516222CE3
	for <linux-scsi@archiver.kernel.org>; Sat, 24 Aug 2019 18:45:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566672321;
	bh=0EifMnHF0dXWeVEJO39RSkX1igyuAB6qFQUFX/o3MXI=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=hA1Myxh5ewC47yh5qHrPc93chmeq3JSLjLabJvMjyiqjwZd+DiM0jjowKXAqTZPYp
	 tZyJyn5+rmE/TGcPtkT6MCSA1pyLLYDV0LYfeZObvGpbTxjXSXLLtVcMBAVCsBZ4Al
	 VQQjcCD9etHOj9D5x3N+j3LVEHXeU9yqfP5AgA/A=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727950AbfHXSpJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 24 Aug 2019 14:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:53876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727912AbfHXSpI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Aug 2019 14:45:08 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.3-rc5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566672308;
        bh=0EifMnHF0dXWeVEJO39RSkX1igyuAB6qFQUFX/o3MXI=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=omEhZJXRsvCDidF32DXFfxtJynZQBrg7wdOD1lGao7ml4zpVJna7JXh9c4nbxgQcM
         VWKI7AXy7EGDtbVJsakJKYF9B36O+fkZtkl48ymv7ugJRM9dl7ViROeAsOxSIz7zTK
         72WDa+hz9Z/d4jhAT4Ou/eA3clHQudxzuObrjZ3c=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1566638608.2975.19.camel@HansenPartnership.com>
References: <1566638608.2975.19.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1566638608.2975.19.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 77ffd3465ba837e9dc714e17b014e77b2eae765a
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 17d0fbf47eb15ab7780cc77b28de070ec37e15c5
Message-Id: <156667230804.2337.8948750981514850563.pr-tracker-bot@kernel.org>
Date:   Sat, 24 Aug 2019 18:45:08 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sat, 24 Aug 2019 10:23:28 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/17d0fbf47eb15ab7780cc77b28de070ec37e15c5

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
