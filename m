Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F997C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Mar 2022 06:15:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232827AbiC2GRZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Mar 2022 02:17:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiC2GRY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Mar 2022 02:17:24 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D804D247C33
        for <linux-scsi@vger.kernel.org>; Mon, 28 Mar 2022 23:15:42 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 479D168AFE; Tue, 29 Mar 2022 08:15:39 +0200 (CEST)
Date:   Tue, 29 Mar 2022 08:15:38 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     martin.petersen@oracle.com, hch@lst.de, linux@roeck-us.net,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: core: sysfs: remove comments that conflict with
 the actual logic
Message-ID: <20220329061538.GA19640@lst.de>
References: <20220329021251.123805-1-liu.yun@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220329021251.123805-1-liu.yun@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
