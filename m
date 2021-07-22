Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E212AC432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:17:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8F4F60EB2
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 19:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbhGVSg7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 14:36:59 -0400
Received: from verein.lst.de ([213.95.11.211]:35727 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhGVSgy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 22 Jul 2021 14:36:54 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 12D5867373; Thu, 22 Jul 2021 21:17:28 +0200 (CEST)
Date:   Thu, 22 Jul 2021 21:17:27 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 19/24] scsi: rename CONFIG_BLK_SCSI_REQUEST to
 CONFIG_SCSI_COMMON
Message-ID: <20210722191727.GA15240@lst.de>
References: <20210712054816.4147559-1-hch@lst.de> <20210712054816.4147559-20-hch@lst.de> <yq1zguew84u.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1zguew84u.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 22, 2021 at 01:51:28PM -0400, Martin K. Petersen wrote:
> 
> Christoph,
> 
> > CONFIG_BLK_SCSI_REQUEST is rather misnamed now as it just enabled
> > building a small amount of code shared by the scsi initiator, target
> > and consumers of the scsi_request passthrough API.  Rename it and also
> > allow building it as a module.
> 
> Build now fails. Needs:

Interesting - this did not show up in any of my builds and not in weeks
of buildbot coverage.  But I'll add the include just to be on the safe
side.
