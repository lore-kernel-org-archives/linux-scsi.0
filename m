Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46E1AC04A95
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 17:05:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233895AbiI1RFp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 13:05:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiI1RFo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 13:05:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71F7A895FB;
        Wed, 28 Sep 2022 10:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CBA9F61F41;
        Wed, 28 Sep 2022 17:05:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5CF0C433C1;
        Wed, 28 Sep 2022 17:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664384741;
        bh=VDs/ubAyB01Bk9H5AnuMOTc54FSGl71vk6BJ6hTW0pU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rDgKAr6Cw8wkQ/wI7lEfXnYGOfcCSdu7c9xghoTABGB1xiSss1RLGDAPU3DlQAyEY
         i+q/2lIILYrV8XVcgzQNNxLgNqVsJ/Gd61DXg6tKxU/A3jPhsZhN/i6/i65lMNr9ER
         YU/tYAXrviHWVjWjKQ9YQrDg1ENN6AlbHO/NjgVoIkheZvU3aewIm0GjQEI/LTH4bm
         u8NN/T/dAOSv6yhJNmBNejex+1DRh6o9h+K2VVNU6YkXfZhrMCdeFophjOJbXz6An7
         n5enakffflHC1vGL2lMeZ896OclKXGTjf0cf34T5P/+EsEELoAhP6Zq90trD9TlDwt
         KkkSVa/bz6Pog==
Date:   Wed, 28 Sep 2022 11:05:38 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
Subject: Re: [PATCHSET v2 0/5] Enable alloc caching and batched freeing for
 passthrough
Message-ID: <YzR+4mVQCnI26Ew2@kbusch-mbp.dhcp.thefacebook.com>
References: <20220927014420.71141-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220927014420.71141-1-axboe@kernel.dk>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Series looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
