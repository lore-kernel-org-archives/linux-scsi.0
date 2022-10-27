Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13789FA3742
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiJ0RHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:07:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237006AbiJ0RHF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:07:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAACC193EE5;
        Thu, 27 Oct 2022 10:07:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75501B82717;
        Thu, 27 Oct 2022 17:07:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 200B8C433B5;
        Thu, 27 Oct 2022 17:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890422;
        bh=PS6+Xi/4jP1uyGFN6iRSyMDmBVsZ3ROt6Z9c9whqU28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J7HPxRtgyv56qGLw+D7Urga1D00PFks4xYl9Ly59kDGb3L5exeEIIvSbtbR3zspkZ
         rpwST8eS9vg9UyApO4onunkcq9RuLXGXWbqWdBWdNj7Sw5u/nz6HM+P2gn1L7IdWuz
         FXg2Uu+R1MZbCgLeg1lz3MQ/3IVgG09W7chzjSyT/s+QqngkXPyysYQN9LJMyleQIV
         iZtRM/OOB33xrNsqr/ifqUh7zp1n8FRlXl5nOS1aCf6F0yy8/3Y7Sl6RSAdoyztBDV
         1TWUlzMdcnGjgW2z8R43OYSarj8GxS7S0W7n4pqSzf8I1FieDPaGrkj1yx6ck0XiPw
         M2wBGSTzfmTRg==
Date:   Thu, 27 Oct 2022 11:06:58 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v3 08/19] nvme: Move pr code to it's own file
Message-ID: <Y1q6so/3Hx9GZmTz@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-9-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026231945.6609-9-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 26, 2022 at 06:19:34PM -0500, Mike Christie wrote:
> This patch moves the pr code to it's own file because I'm going to be
> adding more functions and core.c is getting bigger.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>

Good idea. The nvme core file is getting a bit too big and too diverse
in its responsibilities.

Reviewed-by: Keith Busch <kbusch@kernel.org>
