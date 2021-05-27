Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F89C47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 08:02:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B07961090
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 08:02:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbhE0IDV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 May 2021 04:03:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235010AbhE0IDE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 May 2021 04:03:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E208C061574;
        Thu, 27 May 2021 01:01:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XD30i9lyjqWzjdlV8G2qQlwX5r7P+LScMiZQASEL5jI=; b=hc9X6fCnEnnUozgZoaL8BYMaop
        0CUh6XoT+5AyeBYoMtYjqhLOpxyfnjPjTuvKmu9ke8k3dbStBkUbGKs1TAQiNXqkPt/0YbYtG372d
        iQgLQrAlTYFzcsxKbOvgYNoL87l1tuCi5fiArb2bREe9+vh6I+Tg0Z7m8sLE1s2ligQ6P5NJgE0s+
        1zb4KlKSyvhGPgAEW0WagUPexz+4QuY+KRI7dDnVaH2SmYZ32kCPoOLS7pLiFX4ph8bmB5vefM3D0
        I7KcOU9iEPkUUZ4w4z/tcaGls5tu4GEFgUpDKHNWH5cJTINdBE/s+7yWsx92SMFHnIblGSl4vpaX5
        SJnAQ27w==;
Received: from hch by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lmAwD-005JIL-MT; Thu, 27 May 2021 08:00:23 +0000
Date:   Thu, 27 May 2021 09:00:17 +0100
From:   Christoph Hellwig <hch@infradead.org>
To:     jongmin jeong <jjmin.jeong@samsung.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, cang@codeaurora.org,
        beanhuo@micron.com, adrian.hunter@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] scsi: ufs: add quirk to handle broken UIC command
Message-ID: <YK9RkXoLsUT38cTP@infradead.org>
References: <20210527030901.88403-1-jjmin.jeong@samsung.com>
 <CGME20210527031219epcas2p313fcf248833cf14ec9a164dd91a1ca13@epcas2p3.samsung.com>
 <20210527030901.88403-2-jjmin.jeong@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527030901.88403-2-jjmin.jeong@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 27, 2021 at 12:08:59PM +0900, jongmin jeong wrote:
> samsung ExynosAuto SoC has two types of host controller interface to
> support the virtualization of UFS Device.
> One is the physical host(PH) that the same as conventaional UFSHCI,
> and the other is the virtual host(VH) that support data transfer function only.

You forgot to include the hunk that actually sets the quirk.

Also please work on the commit log formatting.

> Change-Id: Ie528726b29bcb643149440bf1c90eaa5995c5ac1

This kind of crap has no business in a commit log.
