Return-Path: <SRS0=X8O6=76=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86FDC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:28:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82E0F2158C
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Jun 2020 16:28:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592411311;
	bh=RRDzhJW1JxlzjxT0fcq7y1Y+XBmrUJBMFobvtm1y+Ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=x25OSbDCnK+WdxaSmM1lcQorzygFZDk+3ic67aJWz4Qm1ukI9IomfrfbYH4XDz7Yw
	 SsPpXH7qlc6YDh9ThkVtn4U24nCkOov2gR+TwxsTL78jnonmfrZ3H3DRZfqiOMh5Pc
	 Ywj5W2lH/Sp2S6yFtXeCNLnsEO01U/b55K1BU7mM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbgFQQ2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Jun 2020 12:28:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726864AbgFQQ23 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 17 Jun 2020 12:28:29 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09F0A208D5;
        Wed, 17 Jun 2020 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592411309;
        bh=RRDzhJW1JxlzjxT0fcq7y1Y+XBmrUJBMFobvtm1y+Ys=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BNNd9E9RFrGAqhGIkCatT9boCEOiPVMAlDGocngBF6m8H9wbpvBFduKu9x1NP2Kyb
         26v07l2PZlxYxJISSEOvwS3lK9ko5ZgqCflLchPhabSAzb8eVwCC0WDjz+k5nRrspV
         2hYo1lgEKNhpT4e9O4sbcJxbJtewH1SHALXfUnSk=
Date:   Wed, 17 Jun 2020 09:28:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200617162827.GD1138@sol.localdomain>
References: <20200617081841.218985-1-satyat@google.com>
 <20200617081841.218985-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200617081841.218985-4-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 17, 2020 at 08:18:41AM +0000, Satya Tangirala wrote:
> Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> encryption additions and the keyslot manager.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

I had also given Reviewed-by on this one; looks like that was missed as well :-)

https://lkml.kernel.org/linux-scsi/20200514051205.GB14829@sol.localdomain/

- Eric
