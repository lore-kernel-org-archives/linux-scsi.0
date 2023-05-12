Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F024C7EE2A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 May 2023 13:01:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240854AbjELNBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 May 2023 09:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240512AbjELNAw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 May 2023 09:00:52 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 026079004;
        Fri, 12 May 2023 06:00:49 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 4B6AC68B05; Fri, 12 May 2023 15:00:43 +0200 (CEST)
Date:   Fri, 12 May 2023 15:00:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Chaitanya Kulkarni <kch@nvidia.com>
Cc:     linux-block@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        axboe@kernel.dk, colyli@suse.de, kent.overstreet@gmail.com,
        agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
        song@kernel.org, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com
Subject: Re: [RFC PATCH] block: add meaningful macro for flush op flags
Message-ID: <20230512130042.GA29078@lst.de>
References: <20230512080757.387523-1-kch@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230512080757.387523-1-kch@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hell no.  This is just obsfucation.  We can look into actually exposing
REQ_OP_FLUSH at the bio level, but not something like this.

