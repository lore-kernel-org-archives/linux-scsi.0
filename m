Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39C6DC4332F
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Dec 2022 08:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229724AbiLOIOJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Dec 2022 03:14:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbiLOIOH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Dec 2022 03:14:07 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB89E2C130
        for <linux-scsi@vger.kernel.org>; Thu, 15 Dec 2022 00:14:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1CA2668AA6; Thu, 15 Dec 2022 09:14:03 +0100 (CET)
Date:   Thu, 15 Dec 2022 09:14:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     john.g.garry@oracle.com, bvanassche@acm.org, mwilck@suse.com,
        hch@lst.de, martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
Subject: Re: [PATCH v3 06/15] scsi: core: Convert to scsi_execute_cmd
Message-ID: <20221215081403.GC3308@lst.de>
References: <20221214235001.57267-1-michael.christie@oracle.com> <20221214235001.57267-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221214235001.57267-7-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
