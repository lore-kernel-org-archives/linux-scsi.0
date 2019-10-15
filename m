Return-Path: <SRS0=R+5F=YI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BA0BECE59D
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 22:25:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F3B92067B
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Oct 2019 22:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1571178308;
	bh=GWtoYLouoEUtiIUBaW8ZMAl2graqxJ0lem6OOb/gf7k=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=ILyUNrMQBW2JRDWBBvNQb6IUn9Kj3A/RU2qkxwysHqYz4jOEajxOXX9j+s8cU7WQp
	 4rhPjXwzNS9WpazacaGP6qhI91FxaXFVDltaiWU/mQFjN6KhpA5oXSaigXU7zVbG+y
	 SNCoBSw4jOvP7okI679fdBH0RDe/04oAcyfb+SIk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732416AbfJOWZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Oct 2019 18:25:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726417AbfJOWZI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Oct 2019 18:25:08 -0400
Subject: Re: [GIT PULL] SCSI fixes for 5.4-rc3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571178307;
        bh=GWtoYLouoEUtiIUBaW8ZMAl2graqxJ0lem6OOb/gf7k=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=LphwLpoyJTTWCoIJe5m0mUlZCI7mn12BuHX+0U4POorgLnGR2l0/Kn72ZXJ3ANMXo
         eSYdc1tKpl8KXbhpagkAL65YaAqZC2c3/GcmBjHMEND0HrQLUOZrFLtmMhVRMf/VYb
         GMv9Z5yXbV71NBa9X7P+oqOTckFYgnL1cBHoIL58=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1571166922.15362.19.camel@HansenPartnership.com>
References: <1571166922.15362.19.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1571166922.15362.19.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: b23f330d5145b92f90cf16f1adc5444ad06764b4
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 8625732e7712882bd14e1fce962bdc3c315acd41
Message-Id: <157117830755.470.5428874714764092445.pr-tracker-bot@kernel.org>
Date:   Tue, 15 Oct 2019 22:25:07 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Tue, 15 Oct 2019 15:15:22 -0400:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/8625732e7712882bd14e1fce962bdc3c315acd41

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
