Return-Path: <SRS0=GUYw=3P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB19C35246
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 19:30:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A1220716
	for <linux-scsi@archiver.kernel.org>; Sun, 26 Jan 2020 19:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580067005;
	bh=sswafWh0bce4nJg4cq0HPNM+Oz11gZKF0zgYNF5sVKE=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=yWC2qPf43KYTMH5Yq29gJgoAl5fHuGM9lWGu6z/pHevIGCfDmxBzSGMiNZ2Z86kd2
	 hQi5SzZA2O5yifsyFtUcsv8EhgBxt9bP3Ef5kwzAqFz5MBmiCdmqijrRiZAOd3JVVk
	 Y+dnLbtu3w3qnKYcKLaL1vvOZduYmAl1YtBEwfDA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729075AbgAZTaF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 26 Jan 2020 14:30:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:57554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725838AbgAZTaF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 26 Jan 2020 14:30:05 -0500
Subject: Re: [GIT PULL] more SCSI fixes for 5.5-rc7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580067004;
        bh=sswafWh0bce4nJg4cq0HPNM+Oz11gZKF0zgYNF5sVKE=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=nJkEJrraW+s3C3ku40CqA58QLt+7SCT7hD/7bEUeLtRx6HMyxaztZs3i3deN4b6y0
         8Nt6IhxLsHr2yAi/L8RZPMm9ZJlyE0Cq+uBW885CoznPHt18lkNiuITCaFV7tHp+wK
         23qBe1M6l2SirArj40zeXWoZoPKhiMJRqg79TU5A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <1580063451.4964.17.camel@HansenPartnership.com>
References: <1580063451.4964.17.camel@HansenPartnership.com>
X-PR-Tracked-List-Id: <linux-kernel.vger.kernel.org>
X-PR-Tracked-Message-Id: <1580063451.4964.17.camel@HansenPartnership.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes
X-PR-Tracked-Commit-Id: 04060db41178c7c244f2c7dcd913e7fd331de915
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 54343d951838ef4e423de7d124616bf66eca92e7
Message-Id: <158006700455.5558.5366678131439932986.pr-tracker-bot@kernel.org>
Date:   Sun, 26 Jan 2020 19:30:04 +0000
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The pull request you sent on Sun, 26 Jan 2020 10:30:51 -0800:

> git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/54343d951838ef4e423de7d124616bf66eca92e7

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
