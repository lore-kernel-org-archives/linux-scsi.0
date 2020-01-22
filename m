Return-Path: <SRS0=vnQa=3L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ADF7C33CB6
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 18:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5095E24656
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jan 2020 18:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579717339;
	bh=VRpJ4OQCxwNuMHi7OB1+vUTbgYYnhoJNXYt4shp4GBE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sFAT07Zty+oRjvDLJPkqyH1A+1KGxhQjhoCSD9QYtwncz9bPc+SrUrLBPXwlUWW5p
	 L5zhzcFYbuvDcFhQlY32Ug/P75HNxRyl+IGAYH6Kvjw1jROVHUmDFjJM8CvR5BG+Y4
	 t9EafLcBCxoAZPQAuygUnbAZg0iMFhPWiD8ciPY8=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgAVSWR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 13:22:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:40168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgAVSWR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 13:22:17 -0500
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AB0E24125;
        Wed, 22 Jan 2020 18:22:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579717336;
        bh=VRpJ4OQCxwNuMHi7OB1+vUTbgYYnhoJNXYt4shp4GBE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ILrlwPIX+qlULPuwQqz6MFuGc7wLA4/ByKGPSQfKrO6+jyz1Hrl83at0hXH0BtA1R
         PntcStdGNQLNL+LajWAoTConMb4YgUMizf9YOZ13NDpVj3tVRegN9iGNW3e2HRnsh8
         uMyHBA/QOx2NftWhfaEKH2PujkeTF3LahSGscgxQ=
Date:   Wed, 22 Jan 2020 20:22:13 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Michal Kalderon <mkalderon@marvell.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Ariel Elior <aelior@marvell.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [EXT] Re: [PATCH net-next 13/14] qed: FW 8.42.2.0 debug features
Message-ID: <20200122182213.GJ7018@unreal>
References: <20200122152627.14903-1-michal.kalderon@marvell.com>
 <20200122152627.14903-14-michal.kalderon@marvell.com>
 <20200122075416.608979b2@cakuba>
 <MN2PR18MB3182F7A15298B22C7CC5B64FA10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
 <20200122161451.GH7018@unreal>
 <MN2PR18MB318296DAE2E98F3BD34B3675A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN2PR18MB318296DAE2E98F3BD34B3675A10C0@MN2PR18MB3182.namprd18.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 22, 2020 at 04:41:10PM +0000, Michal Kalderon wrote:
> > From: Leon Romanovsky <leon@kernel.org>
> > Sent: Wednesday, January 22, 2020 6:15 PM
> >
> > External Email
> >
> > ----------------------------------------------------------------------
> > On Wed, Jan 22, 2020 at 04:03:04PM +0000, Michal Kalderon wrote:
> > > > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > > > owner@vger.kernel.org> On Behalf Of Jakub Kicinski
> > > >
> > > > On Wed, 22 Jan 2020 17:26:26 +0200, Michal Kalderon wrote:
> > > > > Add to debug dump more information on the platform it was
> > > > > collected from (kernel version, epoch, pci func, path id).
> > > >
> > > > Kernel version and epoch don't belong in _device_ debug dump.
> > > This is actually very useful when customers provide us with a debug-dump
> > using the ethtool-d option.
> > > We can immediately verify the linux kernel version used.
> >
> > Why can't they give you "uname -a" output?
> Unfortunately, history has shown us that in many cases even though requested uname -a is not
> Provided, or worse, provided but does not match the actual kernel run on.
> Having this information in the dump helps us and provides us with more confidence than uname -a output.

I don't buy it, if user can't provide adequate "uname -a", you can't
trust his "ethtool -d" dump file too.

Thanks

>
> >
> > Thanks
