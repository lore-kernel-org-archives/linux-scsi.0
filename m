Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33024C7EE43
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 04:35:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239545AbjFMEfa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 00:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240038AbjFMEe7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 00:34:59 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B67D10E3;
        Mon, 12 Jun 2023 21:34:54 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id A0C6568B05; Tue, 13 Jun 2023 06:34:51 +0200 (CEST)
Date:   Tue, 13 Jun 2023 06:34:51 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 5/7] scsi: don't wait for quiesce in
 scsi_device_block()
Message-ID: <20230613043451.GB13400@lst.de>
References: <20230612165049.29440-1-mwilck@suse.com> <20230612165049.29440-6-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612165049.29440-6-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> - * Pause SCSI command processing on the specified device and wait until all
> - * ongoing scsi_queue_rq() calls have finished. May sleep.
> + * Pause SCSI command processing on the specified device. Callers must wait until all

Please avoid the overly long line here.

Except for that:

Reviewed-by: Christoph Hellwig <hch@lst.de>
