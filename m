Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70917C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 06:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245550AbiCOGbG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 02:31:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345210AbiCOGbD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 02:31:03 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0E6A4924E;
        Mon, 14 Mar 2022 23:29:50 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 3EF3868AFE; Tue, 15 Mar 2022 07:29:48 +0100 (CET)
Date:   Tue, 15 Mar 2022 07:29:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_ioctl:drop needless assignment in sg_io()
Message-ID: <20220315062948.GB1086@lst.de>
References: <20220315061520.30745-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315061520.30745-1-lukas.bulwahn@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 15, 2022 at 07:15:20AM +0100, Lukas Bulwahn wrote:
> Commit ce70fd9a551a ("scsi: core: Remove the cmd field from struct
> scsi_request") refactored sg_io(), so that it does not allocate directly
> and hence does not return -ENOMEM in its error case. That makes a
> remaining assignment of -ENOMEM to the return variable needless.
> 
> Drop this needless assignment in sg_io().
> 
> No functional change. No change in resulting object code.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
