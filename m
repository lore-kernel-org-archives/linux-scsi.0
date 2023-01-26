Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45F28C61D97
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Jan 2023 05:26:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235786AbjAZF0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Jan 2023 00:26:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjAZF03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jan 2023 00:26:29 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9D0A47ED3;
        Wed, 25 Jan 2023 21:26:28 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3565968D09; Thu, 26 Jan 2023 06:26:25 +0100 (CET)
Date:   Thu, 26 Jan 2023 06:26:24 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Keith Busch <kbusch@kernel.org>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority
 class
Message-ID: <20230126052624.GA28310@lst.de>
References: <20230124190308.127318-1-niklas.cassel@wdc.com> <20230124190308.127318-2-niklas.cassel@wdc.com> <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org> <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com> <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org> <4c345d8b-7efa-85c9-fe1c-1124ea5d9de6@opensource.wdc.com> <5066441f-e265-ed64-fa39-f77a931ab998@acm.org> <275993f1-f9e8-e7a8-e901-2f7d3a6bb501@opensource.wdc.com> <Y9G3LUem6X/fUz22@kbusch-mbp.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9G3LUem6X/fUz22@kbusch-mbp.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 25, 2023 at 04:11:41PM -0700, Keith Busch wrote:
> I wouldn't necessarily rule out CDL for PCI attached in some future TP. NVMe
> does allow rotating media, and they'll want feature parity if CDL is considered
> useful in other protocols.

NVMe has a TP for CDL that is technically active, although it doesn't
seem to be actively worked on right now.
