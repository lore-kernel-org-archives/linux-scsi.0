Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4FAEC7EE43
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jun 2023 04:35:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238754AbjFMEfQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jun 2023 00:35:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239775AbjFMEel (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jun 2023 00:34:41 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3CEF2130;
        Mon, 12 Jun 2023 21:33:57 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C4A4D68B05; Tue, 13 Jun 2023 06:33:53 +0200 (CEST)
Date:   Tue, 13 Jun 2023 06:33:53 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v5 4/7] scsi: don't wait for quiesce in
 scsi_stop_queue()
Message-ID: <20230613043353.GA13400@lst.de>
References: <20230612165049.29440-1-mwilck@suse.com> <20230612165049.29440-5-mwilck@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230612165049.29440-5-mwilck@suse.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
