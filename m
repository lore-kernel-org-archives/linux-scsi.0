Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C5C3C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:03:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 447232080C
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 20:03:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbgHLUDe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 16:03:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:48088 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgHLUDd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Aug 2020 16:03:33 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id E46FEAFBA;
        Wed, 12 Aug 2020 20:03:53 +0000 (UTC)
Message-ID: <5a9a0ad8432a8e55304b25a472a658b77d377b38.camel@suse.com>
Subject: Re: [PATCH 0/7] smartpqi updates
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microsemi.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, bader.alisaleh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        hch@infradead.org, jejb@linux.vnet.ibm.com,
        joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Wed, 12 Aug 2020 22:03:30 +0200
In-Reply-To: <159622890296.30579.6820363566594432069.stgit@brunhilda>
References: <159622890296.30579.6820363566594432069.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.36.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2020-07-31 at 16:01 -0500, Don Brace wrote:
> These patches are based on Linus's tree
> 
> The changes are:
> smartpqi-identify-physical-devices-without-issuing-INQUIRY
>  - eliminate sending INQUIRYs to physical devices
> smartpqi-add-id-support-for-smartRAID-3152-8i
>  - add support for a new controller
> smartpqi-update-logical-volume-size-after-expansion
>  - update volume size in OS after expansion.
> smartpqi-avoid-crashing-kernel-for-controller-issues
>  - remove BUG calls for rare cases when controller returns
>    bad responses.
> smartpqi-support-device-deletion-via-sysfs
>  - handle device removal using sysfs file
>    /sys/block/sd<X>/device/delete where X is device name is a, b, ...
> smartpqi-add-RAID-bypass-counter
>  - aid to identify when RAID bypass is in use.
> smartpqi-bump-version-to-1.2.16-010
> 
> ---
> 
> Don Brace (1):
>       smartpqi: bump version to 1.2.16-010
> 
> Kevin Barnett (4):
>       smartpqi identify physical devices without issuing INQUIRY
>       smartpqi: avoid crashing kernel for controller issues
>       smartpqi: support device deletion via sysfs
>       smartpqi: add RAID bypass counter
> 
> Mahesh Rajashekhara (2):
>       smartpqi: add id support for SmartRAID 3152-8i
>       smartpqi: update logical volume size after expansion
> 
> 
>  drivers/scsi/smartpqi/smartpqi.h      |   4 +-
>  drivers/scsi/smartpqi/smartpqi_init.c | 301 ++++++++++++++++------
> ----
>  2 files changed, 189 insertions(+), 116 deletions(-)
> 
> --

For this series:
Reviewed-by: Martin Wilck <mwilck@suse.com>

Nitpick: It'd be nice to the separate functional changes from
whitespace and formatting fixes for easier review.


