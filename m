Return-Path: <SRS0=Cu6i=6O=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59A50C47254
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:02:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A3A214D8
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Apr 2020 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588266162;
	bh=KyZuJnDBqEdGS6iPd0QsY0M5oYS5mvkpln5O+Lo+8+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=nQ4gitSdjIASwsBiqJXw/WemHQMaSy0HzUsPQtFOMxcvMLDS4kH7jkyoXn66YiXDo
	 i6NSMe4uk6XsU8axM6N16eQ1rXGtL49JTNlmmi5HV2/zRXc1IaTRNmPuZN00VnQIiz
	 n3keQL/cgfW698TyJbSi04T3uAvp0hfJ2xOpXG+0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726672AbgD3RCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Apr 2020 13:02:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:49670 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726440AbgD3RCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Apr 2020 13:02:41 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A4B720787;
        Thu, 30 Apr 2020 17:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588266160;
        bh=KyZuJnDBqEdGS6iPd0QsY0M5oYS5mvkpln5O+Lo+8+w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLXYWxhR97lhm1QqB4s/La6Baka75kWzkYwMsHuQcUnNEUisGpvdwC8LrmJ+1L5Hh
         kbu7U8SLxdXVpPtxUXUEG0B46G8E9DAOYRz+0I7pW7zMpZjvXOeEDIiPKi8UBcYYmI
         rBPBZEqP7AS27RXTEObKuIwLfjDPZF+M4NANJcxg=
Date:   Thu, 30 Apr 2020 10:02:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org,
        Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>
Subject: Re: [PATCH v12 00/12] Inline Encryption Support
Message-ID: <20200430170233.GA1003@sol.localdomain>
References: <20200430115959.238073-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200430115959.238073-1-satyat@google.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 30, 2020 at 11:59:47AM +0000, Satya Tangirala wrote:
> This patch series adds support for Inline Encryption to the block layer,
> UFS, fscrypt, f2fs and ext4.

Thanks, that was fast!  As usual I pushed this out to

        Repo: https://git.kernel.org/pub/scm/fs/fscrypt/fscrypt.git
        Tag: inline-encryption-v12

- Eric
