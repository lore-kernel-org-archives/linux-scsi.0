Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B2EBC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 13:28:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235507AbiI2N2S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:28:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235657AbiI2N1k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 09:27:40 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D841B2D30;
        Thu, 29 Sep 2022 06:27:02 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id F242568BFE; Thu, 29 Sep 2022 15:26:53 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:26:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v11 07/13] block: add blk_rq_map_user_bvec
Message-ID: <20220929132653.GC27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121653epcas5p4ee82ef35b46d6686820dc4d870b6588e@epcas5p4.samsung.com> <20220929120632.64749-8-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-8-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Please fold this into the next patch - adding a static helper without
users will cause a compiler warning, or even an error with pinheads
favourite -Werror setting.

