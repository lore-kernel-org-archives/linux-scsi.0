Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C76C54E94
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Jan 2023 06:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234138AbjAYGeB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Jan 2023 01:34:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230160AbjAYGeA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jan 2023 01:34:00 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF243F2B0;
        Tue, 24 Jan 2023 22:33:58 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 093C76732D; Wed, 25 Jan 2023 07:33:55 +0100 (CET)
Date:   Wed, 25 Jan 2023 07:33:54 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 01/18] block: introduce duration-limits priority
 class
Message-ID: <20230125063354.GA1766@lst.de>
References: <20230124190308.127318-1-niklas.cassel@wdc.com> <20230124190308.127318-2-niklas.cassel@wdc.com> <bd0ce7ad-cf9e-a647-9b1e-cb36e7bbe30f@acm.org> <731aeacc-74c0-396b-efa0-f9ae950566d8@opensource.wdc.com> <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <873e0213-94b5-0d81-a8aa-4671241e198c@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jan 24, 2023 at 02:43:24PM -0800, Bart Van Assche wrote:
> What if a device that supports I/O priorities (e.g. an NVMe device that 
> supports configuring the SQ priority)

NVMe does not have any I/O priorities, it only has a very limited
priority scheme for queue arbitration.
