Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF0E1C4321E
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 13:28:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235704AbiI2N2T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 09:28:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235703AbiI2N1m (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 09:27:42 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0666211E97E;
        Thu, 29 Sep 2022 06:27:15 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4EE9B68C4E; Thu, 29 Sep 2022 15:27:12 +0200 (CEST)
Date:   Thu, 29 Sep 2022 15:27:12 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Anuj Gupta <anuj20.g@samsung.com>
Cc:     axboe@kernel.dk, hch@lst.de, kbusch@kernel.org,
        io-uring@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org, gost.dev@samsung.com,
        linux-scsi@vger.kernel.org, Kanchan Joshi <joshi.k@samsung.com>
Subject: Re: [PATCH for-next v11 09/13] nvme: pass ubuffer as an integer
Message-ID: <20220929132712.GD27768@lst.de>
References: <20220929120632.64749-1-anuj20.g@samsung.com> <CGME20220929121701epcas5p287a6d3f851626a5c7580d9a534432e9b@epcas5p2.samsung.com> <20220929120632.64749-10-anuj20.g@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220929120632.64749-10-anuj20.g@samsung.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
