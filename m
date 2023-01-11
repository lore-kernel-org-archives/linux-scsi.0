Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55A55C54EBC
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Jan 2023 15:27:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234394AbjAKP1z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Jan 2023 10:27:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238568AbjAKP1w (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Jan 2023 10:27:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAF59A474;
        Wed, 11 Jan 2023 07:27:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4226961AB3;
        Wed, 11 Jan 2023 15:27:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2867AC433EF;
        Wed, 11 Jan 2023 15:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673450870;
        bh=xYkT8bdWjhUslq2g+W22F0PwGEq3eIcP26A0yseWI5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XiLLTO5AaHnJ8kh0HI81mAXrV2Z8ffw4usI6+9xfSRLk4cDyD9M60BubEn+Lp/S1u
         BvII+KlDf6MFl20WuUF1jNWU3jvBM8XiSToMqBEY53qHnaBmU7xyY2DsfCeJtyLovG
         jFvM1M04+KT+cqpk8ydkBG3+Frt9O9JfyRzIFDdng5TFyKnT75L0NrDkvG+KpAnfaF
         bwa45y0OPsUs9rl2ncEeIdeWBmHcUUFM1e44ZG4Q5XDeqK8a6WqrnRLJDDw6LLV4yM
         v4WMt9W90vNgqhbmA8PX5nEePNgV6iN+szap7O2w2sJDkjXSbyFkWzP7kFCgZIEvG7
         5iTpWXOLY0w7w==
Date:   Wed, 11 Jan 2023 08:27:47 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: SG_IO ioctl regression
Message-ID: <Y77Vcz3dpll2WoV/@kbusch-mbp.dhcp.thefacebook.com>
References: <20230105190741.2405013-6-kbuschmeta!com>
 <Y77J/w0gf2nIDMd/@x1-carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y77J/w0gf2nIDMd/@x1-carbon>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 11, 2023 at 02:38:56PM +0000, Niklas Cassel wrote:
> It appears that this commit breaks SG_IO ioctl.

Thanks for the catch. I'll send either a fix or revert today.
