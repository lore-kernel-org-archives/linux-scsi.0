Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20E0AC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 14:34:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239803AbiESOeX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 10:34:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239822AbiESOeR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 10:34:17 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4968EAD2D;
        Thu, 19 May 2022 07:34:10 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 0BB6668AFE; Thu, 19 May 2022 16:34:07 +0200 (CEST)
Date:   Thu, 19 May 2022 16:34:06 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>, linux-block@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] blk-cgroup: provide stubs for blkcg_get_fc_appid()
Message-ID: <20220519143406.GA23363@lst.de>
References: <20220519140021.6905-1-hare@suse.de> <20220519140816.GA21378@lst.de> <b34a5081-dcb5-dd33-46f4-283e9d31fc0f@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b34a5081-dcb5-dd33-46f4-283e9d31fc0f@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 19, 2022 at 04:20:40PM +0200, Hannes Reinecke wrote:
>>
>> No, it does not fix that commit, which is perfectly fine.  It fixes
>> the recently added second caller of blkcg_get_fc_appid, and James
>> has just resent a new version of that which fixes this properly.
>
> Really? blk-cgroup.h provides the function declaration
> blkcg_get_fc_appid() unconditionally, but the implementation
> for blkcg_get_fc_appid() depends on CONFIG_CGROUP.

Take a look at the IS_ENABLED macro that we have for a few years now.

> Neither of which is changed by James patchset.
>
> And besides, the first version is already merged.
>
> Am I missing something?

https://lore.kernel.org/linux-scsi/20220519123110.17361-1-jsmart2021@gmail.com/T/#t

