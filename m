Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FSL_HELO_FAKE,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3509DC5519F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 17:05:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C489A24655
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Nov 2020 17:04:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pd3hsnOp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgKQRE7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Nov 2020 12:04:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:49060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726204AbgKQRE7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 17 Nov 2020 12:04:59 -0500
Received: from google.com (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A000B22447;
        Tue, 17 Nov 2020 17:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605632698;
        bh=qB8kWKfr/G1c1HRcXsuojqiZahRkSR01k/osJdzNo5o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Pd3hsnOphSZRf7ZlsqO9YcPuARVSdTu2gGY2W3nPd2IXzq9JaveSLKoPBB+g23s42
         6eUVx2maTyWA8uqy4dZkoYAlPAdyQYlUQI+jR8Nn2X7tGVl0sDtHJ2lz1SlR83Tna3
         LP7t4qakaJs2N+8Xp2TOFNK6B8B70qn8zhsLNrAs=
Date:   Tue, 17 Nov 2020 09:04:57 -0800
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, Leo Liou <leoliou@google.com>
Subject: Re: [PATCH] scsi: ufs: show lba and length for unmap commands
Message-ID: <20201117170457.GD1636127@google.com>
References: <20201112165950.518952-1-jaegeuk@kernel.org>
 <yq1r1os648z.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1r1os648z.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/16, Martin K. Petersen wrote:
> 
> Hi Jaegeuk!
> 
> > From: Leo Liou <leoliou@google.com>
> >
> > We have lba and length for unmap commands.
> >
> > Signed-off-by: Leo Liou <leoliou@google.com>
> 
> Doesn't apply to 5.11/scsi-queue.
> 
> Also needs a Signed-off-by: tag from you.

Hi Martin,

Could you please consider this patch series?

https://lore.kernel.org/linux-scsi/20201117165839.1643377-1-jaegeuk@kernel.org/

Thanks,

> 
> Thanks!
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
