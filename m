Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67BB7C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 14:08:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239020AbiESOIW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 10:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231636AbiESOIU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 10:08:20 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C9F60DAA;
        Thu, 19 May 2022 07:08:19 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3313A68AFE; Thu, 19 May 2022 16:08:16 +0200 (CEST)
Date:   Thu, 19 May 2022 16:08:16 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: provide stubs for blkcg_get_fc_appid()
Message-ID: <20220519140816.GA21378@lst.de>
References: <20220519140021.6905-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220519140021.6905-1-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 19, 2022 at 04:00:21PM +0200, Hannes Reinecke wrote:
> Provide stubs for blkcg_set_fc_appid() and  blkcg_get_fc_appid() to allow
> for compilation with cgroups disabled.
> 
> Fixes: db05628435aa ("blk-cgroup: move blkcg_{get,set}_fc_appid out of line")
> Signed-off-by: Hannes Reinecke <hare@suse.de>

No, it does not fix that commit, which is perfectly fine.  It fixes
the recently added second caller of blkcg_get_fc_appid, and James
has just resent a new version of that which fixes this properly.
