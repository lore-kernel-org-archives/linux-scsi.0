Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64C0EC4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Nov 2022 06:39:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbiKPGjZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Nov 2022 01:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233088AbiKPGih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Nov 2022 01:38:37 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF7B167D8;
        Tue, 15 Nov 2022 22:38:20 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 34EDD68AA6; Wed, 16 Nov 2022 07:38:17 +0100 (CET)
Date:   Wed, 16 Nov 2022 07:38:17 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH v2 1/4] block: Add error codes for common PR failures
Message-ID: <20221116063817.GA19581@lst.de>
References: <20221115212825.7945-1-michael.christie@oracle.com> <20221115212825.7945-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221115212825.7945-2-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
