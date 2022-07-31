Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9742C3F6B0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 Jul 2022 10:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbiGaKqo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 Jul 2022 06:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiGaKqn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 Jul 2022 06:46:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AD41DFB6;
        Sun, 31 Jul 2022 03:46:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3686E60A4B;
        Sun, 31 Jul 2022 10:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46B06C433D6;
        Sun, 31 Jul 2022 10:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659264401;
        bh=M3eRtF83kzIsIL0kR7hbVLVI7cGUhr79ISKJnJAQfMk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uYy5RlrT/2DkzhiaFGLxK3fTTutR9oYyKvggsuq53z/M2HExyCZo94lnEw8S7/JxP
         xsBvtMfvFs3MGk9KYtLZyUo9mcOdrl6YEsC+Z0kSZRCz3ih5nLiVv4MetFgv2D7MnQ
         Gkk516xp6fNdvxP96Ep9bQAGLc3+lwRh1T/ZqSPM=
Date:   Sun, 31 Jul 2022 12:46:39 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     stable@vger.kernel.org, ming.lei@redhat.com,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, yi.zhang@huawei.com
Subject: Re: [PATCH stable 4.19 0/1] fix io hung for scsi
Message-ID: <YuZdjxjYIo5N2qMw@kroah.com>
References: <20220730084651.4093719-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220730084651.4093719-1-yukuai1@huaweicloud.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 30, 2022 at 04:46:50PM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> One of our product reported a io hung problem, turns out the problem
> can be fixed by the patch.
> 
> I'm not sure why this patch is not backported yet, however, please
> consider it in 4.19 lts.

It was not backported as it did not apply as-is.  Can you also provide a
version for 5.4.y so that if someone were to upgrade to a newer kernel
version, they would not have a regression?  Once we have that, then we
can accept this 4.19.y version.

thanks,

greg k-h
