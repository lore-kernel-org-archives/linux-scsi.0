Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A03AFC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 12:20:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 878066112E
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 12:20:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230315AbhJ1MWl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 08:22:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:51264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230192AbhJ1MWj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E27286113B;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423612;
        bh=AA8DxlTDPgFvfZaeVVQREzoiRxKhsDSvwbBN1kezN9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=thvAFcfltIB6EaEOLUzDwIyYlTg2V2FGntXOm+/JaXDHv6J+3P7zjTzR2zo2qr5Yb
         DDj+pTqq2gmlqYUs9YmJ2yF4LYUS6JNuQDhtsgwKbNC9j3D1d0MGl730TBvliUX3TP
         kOrmakvrfaAg4nUKs8TgGx6/i22nG8PSLHsDduC7g+u+ZQdkGGqgPzeI7EjmTnD1SE
         Hqyj1LcTvvj3z04kvtZdWQUOKhZqRRlYDnZRDEFNsZA1MXwOnJCnpYkYa49fRLwpVp
         /C5iOylG5SvirLUSWAKy24Geegiy0NmwOpC74CjTbFU1+PyJwWgrwNgHNBKKtTfcff
         +XNVzLFTSzzMg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mpt fusion: use dev_addr_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361289.29870.15169096796289309187.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <20211026175500.3197955-1-kuba@kernel.org>
In-Reply-To: <20211026175500.3197955-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 10:55:00 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] mpt fusion: use dev_addr_set()
    https://git.kernel.org/netdev/net-next/c/e0b4f1cd36bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


