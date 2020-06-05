Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D8D7C433DF
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:18:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E1BE4207D8
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 19:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591384693;
	bh=PQB1Qt7SuEmoEadO+t4LgnSIisVvIjh+A77iGzGr9kw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=ON//pgFsSL0ezzQ8gHc7H6mCgak2djr6oYp8o85MSAqUFImnMVh+mnHzfzXg4aY3f
	 gMdFcXH+OJ9NJ1VevN6YyeglB+W6O6sYSao2XCHcPoZps996XcfBnxD1hIpH7Tg83V
	 EL87s8Ikf6TcHF8tT7gE1/JWEIHfvG2SZsPNU9Wk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgFETSK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 15:18:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:54596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726963AbgFETSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 5 Jun 2020 15:18:09 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA85207D3;
        Fri,  5 Jun 2020 19:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591384689;
        bh=PQB1Qt7SuEmoEadO+t4LgnSIisVvIjh+A77iGzGr9kw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uQamtu/hlwYDWDSymi+RM62VDi4LcA5Ie+5PL3kUTi5xKYExl4ZBUQ65JlPB0vein
         uyqCNxyL3cvrZ+IqgB7PsZD57jEvs+5apzy5+l6uhdLnaq3PnffiHIoStQJB03QHU7
         SSIhoXfqgtbEh9AtJBb/ZR1HM7HdEASWRYwKEtfQ=
Date:   Fri, 5 Jun 2020 12:18:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bean Huo <huobean@gmail.com>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] scsi: ufs: Add SPDX GPL-2.0 to replace GPL v2
 boilerplate
Message-ID: <20200605191807.GJ1373@sol.localdomain>
References: <20200605191439.19313-1-huobean@gmail.com>
 <20200605191439.19313-2-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200605191439.19313-2-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jun 05, 2020 at 09:14:38PM +0200, Bean Huo wrote:
> From: Bean Huo <beanhuo@micron.com>
> 
> Add SPDX GPL-2.0 to UFS driver files that specified the GPL
> version 2 license, remove the full boilerplate text.
> 
> Signed-off-by: Bean Huo <beanhuo@micron.com>
> ---
>  drivers/scsi/ufs/ufs.h           | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd-pci.c    | 25 +------------------------
>  drivers/scsi/ufs/ufshcd-pltfrm.c | 27 +--------------------------
>  drivers/scsi/ufs/ufshcd.c        | 30 +-----------------------------
>  drivers/scsi/ufs/ufshcd.h        | 27 +--------------------------
>  drivers/scsi/ufs/ufshci.h        | 27 +--------------------------
>  6 files changed, 6 insertions(+), 157 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> index c70845d41449..4df9150769b7 100644
> --- a/drivers/scsi/ufs/ufs.h
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -1,36 +1,11 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
>  /*
>   * Universal Flash Storage Host controller driver
> - *
> - * This code is based on drivers/scsi/ufs/ufs.h
>   * Copyright (C) 2011-2013 Samsung India Software Operations
>   *
>   * Authors:
>   *	Santosh Yaraganavi <santosh.sy@samsung.com>
>   *	Vinayak Holikatti <h.vinayak@samsung.com>
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version 2
> - * of the License, or (at your option) any later version.
> - * See the COPYING file in the top-level directory or visit
> - * <http://www.gnu.org/licenses/gpl-2.0.html>

This actually says GPL v2 or later.  Not GPL v2 only.

- Eric
