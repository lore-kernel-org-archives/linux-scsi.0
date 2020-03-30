Return-Path: <SRS0=+9Kw=5P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7BC0C2D0EB
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 07:33:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 948B12073B
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Mar 2020 07:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585553600;
	bh=GfUsEdJ0D3N5lxMWC5c4oropUh1vbv6jsxmLkuFj26E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=t0oBnbCYcu9w8qMGzXbHUPvy9Rq46Enjrk/GwQgIEVvvWWtXrIEE8ZxzdVdRU1LTA
	 w8W3lj970nCt9JSkv/M1COp3P4CWaQWHGnisYekCFvvi7Yu9jLkzIc1LTdSC6i4D2w
	 Cww4lPcii8NvXaxaXciNXBdWIvaKwl5DpkZ3H3yI=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729513AbgC3HdT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Mar 2020 03:33:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:46650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729344AbgC3HdS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 30 Mar 2020 03:33:18 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CFA32073B;
        Mon, 30 Mar 2020 07:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585553598;
        bh=GfUsEdJ0D3N5lxMWC5c4oropUh1vbv6jsxmLkuFj26E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1YW2u7CeuEeHEx09kCbS6IWVqHGZwYuY2ExuxUZ+n515nrHRE+S5tR4rwteCejnbx
         uO200TBWiuSctYe3l9go0Gq1hXnc2PHcOuAa/F88SM0mNmIoF5+aJBxu1JlA2ffrtV
         iApn8keR0M/ce2CFuKW8SP6IGvk/nLzegRxAkLyc=
Date:   Mon, 30 Mar 2020 10:33:14 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saurav Kashyap <skashyap@marvell.com>
Cc:     martin.petersen@oracle.com, GR-QLogic-Storage-Upstream@marvell.com,
        linux-scsi@vger.kernel.org, jhasan@marvell.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/8] qed/qedf: Firmware recovery, bw update and misc
 fixes.
Message-ID: <20200330073314.GJ2454444@unreal>
References: <20200330063034.27309-1-skashyap@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200330063034.27309-1-skashyap@marvell.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Mar 29, 2020 at 11:30:26PM -0700, Saurav Kashyap wrote:
> Hi Martin,
>
> Kindly apply this series to scsi tree at your earliest convenience.
>
> v1->v2
>  - Function qedf_schedule_recovery_handler marked static
>  - Function qedf_recovery_handler marked static
>
> Thanks,
> ~Saurav
>
> Chad Dupuis (2):
>   qedf: Add schedule recovery handler.
>   qedf: Fix crash when MFW calls for protocol stats while function is
>     still probing.
>
> Javed Hasan (1):
>   qedf: Fix for the deviations from the SAM-4 spec.
>
> Saurav Kashyap (4):
>   qedf: Keep track of num of pending flogi.
>   qedf: Implement callback for bw_update.
>   qedf: Get dev info after updating the params.
>   qedf: Update the driver version to 8.42.3.5.

NAK to this patch.

Thanks
