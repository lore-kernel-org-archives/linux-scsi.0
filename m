Return-Path: <SRS0=Vgdy=EE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62EF4C55179
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 19:24:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 096BB20782
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Oct 2020 19:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1603999453;
	bh=pdykT16/rVEziaaG5RdM3lEtS/w+LI8XiLCAZlcWks4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=YG4f3su7MTKag2tXbLqKtqCylrQBqGl6PSaPsncr4a/vzUntlL+UL7GIPpMPa6XaI
	 iis5H5i7rVkNDvl8LyiO9KS8W1CNv8C1NCVRR8tXQMPWYJHemguLvK2gIMki7YFVYQ
	 8Tm7uIL7tZHhQaXlG1s8F8Fub1JDEq4DAj3o1W9w=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725871AbgJ2TWX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Oct 2020 15:22:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:47516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725774AbgJ2TVt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Oct 2020 15:21:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 050A02076D;
        Thu, 29 Oct 2020 19:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603999308;
        bh=pdykT16/rVEziaaG5RdM3lEtS/w+LI8XiLCAZlcWks4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wvFa+H3ltd/KceNSVzRxuEvb4/yIp8XEWzMhGYowB+Twg2jSJ3L5WyWeusnSBwpn8
         MLGwzanPislMk687l8KcPLRyDB5GIPp9Nv5jMDvN4drnG1SKT1GE0qQKBH5x9VtegP
         uARf1s83D3FCEVBOHmzukS/R4dTxQW3adPDpMses=
Date:   Thu, 29 Oct 2020 20:22:36 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Denis Efremov <efremov@linux.com>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-m68k@lists.linux-m68k.org
Subject: Re: [PATCH 02/18] block: open code kobj_map into in block/genhd.c
Message-ID: <20201029192236.GA991240@kroah.com>
References: <20201029145841.144173-1-hch@lst.de>
 <20201029145841.144173-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201029145841.144173-3-hch@lst.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 29, 2020 at 03:58:25PM +0100, Christoph Hellwig wrote:
> Copy and paste the kobj_map functionality in the block code in preparation
> for completely rewriting it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Yes!

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

After this, you want me to get rid of kobj_map, right?  Or you don't
care as block doesn't use it anymore?  :)

thanks,

greg k-h
