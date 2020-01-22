Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6359C2D0DB
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 16:14:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A1A382071E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 16:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579709698;
	bh=iPqGLJSZlNb147jQAgd9KoM1inhA6uptfJm7FPXGCn0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=DV/6lDF4A8vHvycsylOTZ2vkC7RJt2nQUxzfUc8Yx/4T4IHedb2kYT4uV6WdN4ojr
	 WcPjX/w0txv8takfteHOUC7MiuMqKjhQX60XKiUEYWR/QMKkStgstcy4XAA1tcFk0P
	 lh/mrAEVxckPPJpkseVlcBzXw6zBhYlvwwAirJsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgAVQO4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 11:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47708 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVQO4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 11:14:56 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66EE9206A2;
        Wed, 22 Jan 2020 16:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579709695;
        bh=iPqGLJSZlNb147jQAgd9KoM1inhA6uptfJm7FPXGCn0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Uv2mWKbYKnIdsv1siYF6dUMsCeeqokOa4Wo9DnAeUDPmjmjDxOONUxRkmcwAJ3RXq
         mVpqyUWz55QYW16F+9CoNbyIFcPZrVcAp7LReymh/mMAZJtu6u86t7i2jsyb+3LAEa
         E69vpnL1BjrRay6uT8oXWVAHYT+Fml5N20f8SFjc=
Date:   Wed, 22 Jan 2020 18:14:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Message-ID: <20200122161451.GH7018@unreal>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-14-michal.kalderon@marvell.com>
 <20200122075416.608979b2@cakuba>
 <MN2PR18MB3182F7A15298B22C7CC5B64FA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB3182F7A15298B22C7CC5B64FA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 04:03:04PM +0000, Michal Kalderon wrote:
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Jakub Kicinski
> >
> > On Wed, 22 Jan 2020 17:26:26 +0200, Michal Kalderon wrote:
> > > Add to debug dump more information on the platform it was collected
> > > from (kernel version, epoch, pci func, path id).
> >
> > Kernel version and epoch don't belong in _device_ debug dump.
> This is actually very useful when customers provide us with a debug-dump using the ethtool-d option.
> We can immediately verify the linux kernel version used.

Why can't they give you "uname -a" output?

Thanks
