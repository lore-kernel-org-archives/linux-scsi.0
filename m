Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 839A7CCA473
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 11:46:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244050AbiFCLqw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 07:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235135AbiFCLqv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 07:46:51 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 289D6DF2;
        Fri,  3 Jun 2022 04:46:49 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 6308468AFE; Fri,  3 Jun 2022 13:46:45 +0200 (CEST)
Date:   Fri, 3 Jun 2022 13:46:45 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 0/8] Use block pr_ops in LIO
Message-ID: <20220603114645.GA14309@lst.de>
References: <20220603065536.5641-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603065536.5641-1-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From a highlevel POV this looks good.  I'll do a more detail review in
the next days once I find a little time.  Any chance you could also
wire up the new ops for nvme so that we know the abtractions work right
even for exporting nvme as SCSI?  No need to wire up nvmet for now, but
that would be the logical next step.
