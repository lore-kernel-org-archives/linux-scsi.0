Return-Path: <SRS0=1R64=74=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65EA6C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 23:41:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 372D5207D3
	for <linux-scsi@archiver.kernel.org>; Mon, 15 Jun 2020 23:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592264489;
	bh=4B3zxx0t4t/cAMnTcb1CgWAE+WyO6z4UCRqXbi4xzFg=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:List-ID:From;
	b=ECp/+LloQUadhkkgTZI5LgzwPXRjDTkP32+b2CRIA10QfeZoDeqE8K13SskRYqXC8
	 GsdmtK3i9iMv0zvQUAQZG0rb/c3Tya/eJ5BO4KubIYuBgVN95MclDY0/T45uHBzO9L
	 lQ6WxcKzG0EJZqiAHTgRcyHhEfZ3OnbckLR87sbI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727068AbgFOXlU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Jun 2020 19:41:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725960AbgFOXlR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 15 Jun 2020 19:41:17 -0400
Received: from localhost (fw-tnat.cambridge.arm.com [217.140.96.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B32D20714;
        Mon, 15 Jun 2020 23:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592264477;
        bh=4B3zxx0t4t/cAMnTcb1CgWAE+WyO6z4UCRqXbi4xzFg=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=AxBMUE88327gyD7AWPGhve+Wh8ybmWBfw1Vr5OWesrVIVG7NxKRQswpbnAXtofFbO
         sLu3+N4jgXfA/ewD0/dj0zcDJeqxyFwsdjQymufuXtNvL6JVXHeVeKRAOTHmv+8yXX
         grzN41FYi/g6IrCDmey/eZzzF6h2ijQ5jvrYbNpA=
Date:   Tue, 16 Jun 2020 00:41:15 +0100
From:   Mark Brown <broonie@kernel.org>
To:     Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>
Cc:     linux-gpio@vger.kernel.org, ath10k@lists.infradead.org,
        linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        dri-devel@lists.freedesktop.org, linux-input@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-rdma@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-renesas-soc@vger.kernel.org
In-Reply-To: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
References: <20200609124610.3445662-1-kieran.bingham+renesas@ideasonboard.com>
Subject: Re: [PATCH 00/17] spelling.txt: /decriptors/descriptors/
Message-Id: <159226447507.27673.16785893373246037922.b4-ty@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 9 Jun 2020 13:45:53 +0100, Kieran Bingham wrote:
> I wouldn't normally go through spelling fixes, but I caught sight of
> this typo twice, and then foolishly grepped the tree for it, and saw how
> pervasive it was.
> 
> so here I am ... fixing a typo globally... but with an addition in
> scripts/spelling.txt so it shouldn't re-appear ;-)
> 
> [...]

Applied to

   https://git.kernel.org/pub/scm/linux/kernel/git/broonie/regulator.git for-next

Thanks!

[1/2] regulator: Fix trivial spelling
      commit: d3f3723387f97118c337689fc73e4199fb4331ce
[2/2] regulator: gpio: Fix trivial spelling
      commit: 1f0b740004f09d2f1b716fd6c2fdca81004ded05

All being well this means that it will be integrated into the linux-next
tree (usually sometime in the next 24 hours) and sent to Linus during
the next merge window (or sooner if it is a bug fix), however if
problems are discovered then the patch may be dropped or reverted.

You may get further e-mails resulting from automated or manual testing
and review of the tree, please engage with people reporting problems and
send followup patches addressing any issues that are reported if needed.

If any updates are required or you are submitting further changes they
should be sent as incremental updates against current git, existing
patches will not be replaced.

Please add any relevant lists and maintainers to the CCs when replying
to this mail.

Thanks,
Mark
