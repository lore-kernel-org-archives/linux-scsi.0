Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E42DBC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 05:09:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233588AbiGHFJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 01:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229957AbiGHFJ0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 01:09:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825F274342;
        Thu,  7 Jul 2022 22:09:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27472B82124;
        Fri,  8 Jul 2022 05:09:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F469C341C0;
        Fri,  8 Jul 2022 05:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657256962;
        bh=6V1vhx/gUObKAIONRnrqqe+o20FprZCE1K6zJ1CvgeE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SIR0WZpba+rNcvEMiPufGu9mnTAlsW9EGI3M8drJyHLtEZKAcdfuHx1bopV/vMl0z
         pGS5ucFyDgm3Zgo5dfYXkdbO0ryl0sMj3/l+GqfiIRtIQIGZPVlAKlFSHcHcj0GRwg
         +xjV6uLIH+LE/fmviDriLFOjFJCD5cN14GPjWu8/6RrQBM9UAcg30NydP/tfVB9l5L
         tgp7UWIfups8BkB9zd6lwM29pBu3rSpA7UA46r4D+CSCOZsybPxNvnHcz8xm/q2jsb
         MIh0A7w85yEGpFfl9psmJAcEMuQo7RJXiTs+bfsv+YN78gJIGp5Ww+S7JXol125EYX
         Y5oX2ylKvmonA==
Date:   Fri, 8 Jul 2022 10:39:19 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Chanho Park <chanho61.park@samsung.com>
Cc:     "'Martin K. Petersen'" <martin.petersen@oracle.com>,
        'Kishon Vijay Abraham I' <kishon@ti.com>,
        'Krzysztof Kozlowski' <krzysztof.kozlowski@linaro.org>,
        "'James E . J . Bottomley'" <jejb@linux.ibm.com>,
        'Alim Akhtar' <alim.akhtar@samsung.com>,
        'Bart Van Assche' <bvanassche@acm.org>,
        linux-phy@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: Re: [PATCH v2 0/3] change exynos ufs phy control
Message-ID: <Yse7/9TBRd0vxhL6@matsya>
References: <CGME20220706020540epcas2p37a8b697af2c6786db9e4ed67cf20a40f@epcas2p3.samsung.com>
 <20220706020255.151177-1-chanho61.park@samsung.com>
 <yq17d4o624t.fsf@ca-mkp.ca.oracle.com>
 <000a01d89261$bd2c4df0$3784e9d0$@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000a01d89261$bd2c4df0$3784e9d0$@samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08-07-22, 09:29, Chanho Park wrote:
> > > The first patch is for changing phy clocks manipulation from
> > > controlling each symbol/ref clocks to clk_bulk APIs. The second patch
> > > is for making power on/off sequences between pmu isolation and clk
> > > control.  Finally, the third patch changes the phy on/off and init
> > > sequences from ufs-exynos host driver.
> > 
> > Were you intending this series to go through SCSI or the phy tree?
> 
> I thinks the first two patches are going to phy-tree and you'll need to pick
> the last patch.
> 
> Vinod,
> Could you pick the first two patches in your tree?

Applied 1-2, thanks

-- 
~Vinod
