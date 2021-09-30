Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0DDEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:00:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 826EF61265
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 06:00:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348189AbhI3GCJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 02:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348054AbhI3GCJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 02:02:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B172761152;
        Thu, 30 Sep 2021 06:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632981627;
        bh=YYRrwxDvpm4WWaBqbNcZouKHDF5lzt0xzup+R9u8mAU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PX+KDeZYA87gqHGNGv9EFN4ipb+UIeINTC/MF1S42n1xFRwcgzo5t3K4jDDWG5Lwp
         fa9hVX3KThznWh5RGpFUBUhX0S0cRD96x0fDIWoYpbKF0kzX1iKKWlMsTguupL/SIb
         vQGGPD5wF471MW1FvV/ZgmVcDJFchMDg5Qk6X140=
Date:   Thu, 30 Sep 2021 08:00:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        David Kershner <david.kershner@unisys.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Song Chen <chensong_2000@189.cn>,
        "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Subject: Re: [PATCH v2 81/84] staging: unisys: visorhba: Call scsi_done()
 directly
Message-ID: <YVVSdrNigdBrb1+M@kroah.com>
References: <20210929220600.3509089-1-bvanassche@acm.org>
 <20210929221138.3511208-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210929221138.3511208-2-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Sep 29, 2021 at 03:11:32PM -0700, Bart Van Assche wrote:
> Conditional statements are faster than indirect calls. Hence call
> scsi_done() directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
