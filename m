Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 062B5EB64D9
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jul 2023 12:53:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230170AbjGFMx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jul 2023 08:53:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232700AbjGFMxQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jul 2023 08:53:16 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A6A51BF9;
        Thu,  6 Jul 2023 05:52:56 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 481A167373; Thu,  6 Jul 2023 14:52:53 +0200 (CEST)
Date:   Thu, 6 Jul 2023 14:52:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     mhartmay@linux.ibm.com, bblock@linux.ibm.com, bvanassche@acm.org,
        hch@lst.de, axboe@kernel.dk, yukuai3@huawei.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi/sg: fix checking return value of blk_get_queue()
Message-ID: <20230706125253.GA12842@lst.de>
References: <20230705024001.177585-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230705024001.177585-1-yukuai1@huaweicloud.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ooops, yes:

Reviewed-by: Christoph Hellwig <hch@lst.de>
