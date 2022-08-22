Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D213C28D13
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Aug 2022 06:10:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbiHVGK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Aug 2022 02:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbiHVGKz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Aug 2022 02:10:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA6D126ACA;
        Sun, 21 Aug 2022 23:10:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7EED060DD9;
        Mon, 22 Aug 2022 06:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 569F6C433C1;
        Mon, 22 Aug 2022 06:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661148653;
        bh=kKKsZ4GkII0dFS941IxQN4QTvEsTuDg2s4nEEQ+FGZA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kvqXOYE1Pd4AuAjlw/+eWbvYMpT/j7s+JXzhR5gFg+vXdbtjGLA9pmaF8tfK58JGm
         il/mgp03FCSZANP00nUZVgDlCqsfsyIQEuWg3Fer4Tiy3mAsOyCeQLbV/LTCqJ/++D
         vE4SpGGPv7pe0lHs3SV1kVhbSWBbdgn2YhtrEFTI=
Date:   Mon, 22 Aug 2022 08:10:50 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniil Lunev <dlunev@chromium.org>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Keoseong Park <keosung.park@samsung.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sohaib Mohamed <sohaib.amhmd@gmail.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v7] ufs: core: print UFSHCD capabilities in controller's
 sysfs node
Message-ID: <YwMd6iwUS+EBwXfL@kroah.com>
References: <20220815104739.v7.1.Ibf9efc9be50783eeee55befa2270b7d38552354c@changeid>
 <Yvnq5o5f+qp5zs1c@kroah.com>
 <CAONX=-dc9Uj92SZXuhJOdJSBVYWAzNhx8__QQh8icB2D0ZM1=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAONX=-dc9Uj92SZXuhJOdJSBVYWAzNhx8__QQh8icB2D0ZM1=g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 22, 2022 at 09:59:19AM +1000, Daniil Lunev wrote:
> Hi Greg,
> Can you clarify what specifically is missing from the changelog?

What changelog?  I have no context here (remember, never top-post).

confused,

greg k-h
