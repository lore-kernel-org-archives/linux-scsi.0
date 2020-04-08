Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EC09C2BA1B
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 04:18:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9E512082F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 04:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586319518;
	bh=LuWurOevUtQpDmr3oRDq7/MmAINi+bgGfx3XKH8XzZQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=e2xhGfUrcxGQRjjjsVNlLJSMW7nHBuFprG1QLoSPfs2yxakY9yRSF02vNaV2QPUhq
	 LeoaCvcxsR6lOdnYNVeC12/9+xv2JTsy8yWZ6nFHgkAmFMKzXoXH90b7AP+NaBVnRL
	 7Dsw2EobmAw2UgatUDWnhOIGG4KQftUJ2kXXLyWo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbgDHESi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 00:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgDHESh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Apr 2020 00:18:37 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BE54D2074F;
        Wed,  8 Apr 2020 04:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586319517;
        bh=LuWurOevUtQpDmr3oRDq7/MmAINi+bgGfx3XKH8XzZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SWLEY1/+akcoqA7+hIioMJ2Mt5sfH54Too+8y/a40nnoyK/3lJIWSpKMzKVVtfMDY
         E4QCOBTgsQ7FjChImZKDeQg+dn6OSTF9Nun0qTc3DT1xYWZBm3ZKuN+XEy717PRqYp
         gg6yGQdD1KCAsqrrfeBn58GQXW2kMnW4mJ1Y0DX8=
Date:   Tue, 7 Apr 2020 21:18:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v10 00/12] Inline Encryption Support
Message-ID: <20200408041835.GB80793@sol.localdomain>
References: <20200408035654.247908-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200408035654.247908-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 07, 2020 at 08:56:42PM -0700, Satya Tangirala wrote:
> This patch series adds support for Inline Encryption to the block layer,
> UFS, fscrypt, f2fs and ext4.
> 

This patch series can also be retrieved from

        Repo: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
        Tag: inline-encryption-v10

- Eric
