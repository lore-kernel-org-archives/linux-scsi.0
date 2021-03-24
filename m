Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E986C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 07:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB753619F8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 07:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231833AbhCXHOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 03:14:48 -0400
Received: from verein.lst.de ([213.95.11.211]:35712 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232018AbhCXHOq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Mar 2021 03:14:46 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id 7EB6368B02; Wed, 24 Mar 2021 08:14:44 +0100 (CET)
Date:   Wed, 24 Mar 2021 08:14:44 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, David Disseldorp <ddiss@suse.com>,
        =?iso-8859-1?Q?J=FCrgen_Gro=DF?= <jgross@suse.com>,
        Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>
Subject: Re: [PATCH v2 2/2] target: pscsi: cleanup after failure in
 pscsi_map_sg()
Message-ID: <20210324071444.GD647@lst.de>
References: <20210323212431.15306-1-mwilck@suse.com> <20210323212431.15306-2-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210323212431.15306-2-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 23, 2021 at 10:24:31PM +0100, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> If pscsi_map_sg() fails, make sure to drop references to already
> allocated bios.
> 
> Signed-off-by: Martin Wilck <mwilck@suse.com>

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
