Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E34AC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 05:12:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC42206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 05:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589433129;
	bh=cdFrV7nh7pJqlqa0/pkPvBaYElxzoq3V+cr3ke1Ix5g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=hCptW7o1bPV4TJeLK0WoRxptJVHzRhy0mX/0HDyecsi5W9/m3MIOo2EPKM6U7h+94
	 xAdypyQwcyJl/IAjdV28Strvlqv1E7glCksv92RPJ7epIHOP8yG7/oeLQdwF0zScCP
	 XUdgzlUWKVjNQ4RCaIxLjshsLTL1G0XEr3qYwuXM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725876AbgENFMH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 01:12:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgENFMH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 14 May 2020 01:12:07 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5DFF206D4;
        Thu, 14 May 2020 05:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589433127;
        bh=cdFrV7nh7pJqlqa0/pkPvBaYElxzoq3V+cr3ke1Ix5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=k2VsDoJve1gy0nqVqVKZHvP2YadsKWdsfOk2d6wWgvoInglUMeVyOX0D6k15HOULg
         hcQOk+F1+efu8V0RnZHR/Nwlcpp1qBS8gbxG5coCW4XjhFQ315KR+Vl4v6XHWurap+
         yjR+HEitPXERvDZN0i8LtInW04GRKwswvZBdqjes=
Date:   Wed, 13 May 2020 22:12:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v13 08/12] scsi: ufs: Add inline encryption support to UFS
Message-ID: <20200514051205.GB14829@sol.localdomain>
References: <20200514003727.69001-1-satyat@google.com>
 <20200514003727.69001-9-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200514003727.69001-9-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 14, 2020 at 12:37:23AM +0000, Satya Tangirala wrote:
> Wire up ufshcd.c with the UFS Crypto API, the block layer inline
> encryption additions and the keyslot manager.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>

Looks good, you can add:

    Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
