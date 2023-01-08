Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6DBCC53210
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Jan 2023 17:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233311AbjAHRwx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Jan 2023 12:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbjAHRww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jan 2023 12:52:52 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1078F5AD
        for <linux-scsi@vger.kernel.org>; Sun,  8 Jan 2023 09:52:51 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 41AD568AA6; Sun,  8 Jan 2023 18:52:48 +0100 (CET)
Date:   Sun, 8 Jan 2023 18:52:48 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v4 00/15] scsi: Add struct for args to execution
 functions
Message-ID: <20230108175248.GA23317@lst.de>
References: <20221229190154.7467-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229190154.7467-1-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The whole series looks good to me:

Reviewed-by: Christoph Hellwig <hch@lst.de>
