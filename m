Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DB80C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Apr 2022 05:53:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbiDEFzq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Apr 2022 01:55:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiDEFzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Apr 2022 01:55:43 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3894B237DD
        for <linux-scsi@vger.kernel.org>; Mon,  4 Apr 2022 22:53:46 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id EDB9168AFE; Tue,  5 Apr 2022 07:53:42 +0200 (CEST)
Date:   Tue, 5 Apr 2022 07:53:42 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     "zdi-disclosures@trendmicro.com" <zdi-disclosures@trendmicro.com>,
        "security@kernel.org" <security@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        linux-scsi@vger.kernel.org
Subject: Re: ZDI-CAN-17016: New Vulnerability Report
Message-ID: <20220405055342.GB23698@lst.de>
References: <DM5PR0102MB34776506CDCC1E2FFCF78C4580E09@DM5PR0102MB3477.prod.exchangelabs.com> <20220404091211.GA12805@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220404091211.GA12805@kadam>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Apr 04, 2022 at 12:12:11PM +0300, Dan Carpenter wrote:
> This is a valid double copy bug.  I think/hope that /dev/dpt_i2o can
> only be opened by root so I'm going to CC the public lists.
> 
> Last week we deleted the PMCRAID_PASSTHROUGH_IOCTL ioctl in commit
> f16aa285e618 ("scsi: pmcraid: Remove the PMCRAID_PASSTHROUGH_IOCTL ioctl
> implementation").  The temptation is to delete I2OUSRCMD as well.

I'm all for it.  In fact given how bad the driver is I would not be
sad to see it gone, but last time this came up about 5 years ago there
still were users.
