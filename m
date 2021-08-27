Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 19AFAC432BE
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 15:09:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EDF4C60E73
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Aug 2021 15:09:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245373AbhH0PKn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Aug 2021 11:10:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234159AbhH0PKm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Aug 2021 11:10:42 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10877C061757;
        Fri, 27 Aug 2021 08:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2y8ItP7OxStgqC269xp/vLuhvdyK3bvM8eQwyh+XgTI=; b=AaDw1kC8KI9vZXC710eZrVSVB
        SZuaAwNHAWl/nxee98O5qr4C3qRAbNeBKbR07mfSNm6A8C2w7TSZr9kuEP49xVtF94dBq8BlIUNyu
        oNsvGwHyFt8sowi0x46xF2gDY+pMtFDgbmAqoGqcfvoMsjvq+XpXsZNMjzAB6mRtVktVKoscIUJaq
        OT7UwgXHpTE3juc66Z7/DzwBeV0/Tp8O1jaSRhx3R7ncGKF3RVPgZ7MhrozDSjBGp4G7gewRzTQhW
        heVIWwhLRtzQDWd62YdKoJ66SekZo8iI7A8XZ/2d2f3AoaXFvoKmhq/4nkRSS/BqGyuEpYp4L0peZ
        l5ekv/03w==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:47754)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mJdUD-0001G0-EL; Fri, 27 Aug 2021 16:09:41 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mJdUB-0001tI-2J; Fri, 27 Aug 2021 16:09:39 +0100
Date:   Fri, 27 Aug 2021 16:09:39 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: arm scsi drivers
Message-ID: <20210827150938.GU22278@shell.armlinux.org.uk>
References: <5a72842f-99db-8787-120b-6d85e7884e2d@huawei.com>
 <9552a506-e53a-3fd3-b38e-3cec81e713a6@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9552a506-e53a-3fd3-b38e-3cec81e713a6@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I haven't, sorry.

I have run 5.x kernels on the hardware, and do have a set of patches
kicking around for the SCSI drivers that do some cleanups. It looks
like the fixup is pretty simple from the links you've sent - using
scsi_cmd_to_rq() to get the tag.

That said, I think I may only had one SCSI drive that came anywhere
close to supported tagged queuing, so I never put much effort into
tagged command support. Both acornscsi and fas216 have it disabled
for this reason, so it's probably easier just to rip the tag code
out of these drivers.

Russell.

On Fri, Aug 27, 2021 at 03:55:05PM +0100, John Garry wrote:
> Hi Russell,
> 
> Have you had a chance to consider the below?
> 
> Thanks
> 
> 
> > 
> > Recently we tried to remove scsi_cmnd.tags struct member [0].
> > 
> > However it now shows that some of the arm SCSI drivers continue to use
> > this [1]. I think any other driver usage of this member had been found
> > and removed.
> > 
> > The impression is that the usage of scsi_cmnd.tag in those drivers is
> > quite dubious.
> > 
> > Now checking [2], it appears that you may have had some patches for
> > these drivers locally.
> > 
> > So is that the case? Is this HW still used with bleeding edge kernels?
> > If so, can we fix up this tag management?
> > 
> > [0] https://lore.kernel.org/linux-scsi/6c83bd7f-9fd2-1b43-627f-615467fa55d4@huawei.com/T/#mb47909f38f35837686734369600051b278d124af
> > 
> > 
> > [1] https://lore.kernel.org/linux-scsi/6c83bd7f-9fd2-1b43-627f-615467fa55d4@huawei.com/T/#md5d786e5753083b2f3e8e761b1c69809f82c7485
> > 
> > 
> > [2]
> > https://lore.kernel.org/lkml/20210109174357.GB1551@shell.armlinux.org.uk/
> > 
> > Thanks,
> > John
> 
> 

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
