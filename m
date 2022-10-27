Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69C86FA3740
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 17:05:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236981AbiJ0RFt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 27 Oct 2022 13:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236952AbiJ0RFk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 27 Oct 2022 13:05:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EBF0194FBE;
        Thu, 27 Oct 2022 10:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE602623F4;
        Thu, 27 Oct 2022 17:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 378F8C433D6;
        Thu, 27 Oct 2022 17:05:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666890337;
        bh=S1ooH1MY4BzEoq2AVhkBgYAov+/dNn2DY4f3vpBzPTc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NasyEgbzYmJY6qeIEUVRV8FbROhmKlmGXlHJJDzVA+beKF/XgGweQpHNXj2kze5p4
         LvyOzax7MeAnzml3BXm7zFVfqARseyQub4BoF4DVhPY4xqdzLCfuBq7yjU1qH4wI0m
         3tk8IYGXWIy1WpWN6k1uJ9u0XFQWhAiso3p+x8zVnfr/phuvdNbn+Im8PY8lamu567
         RcwY4HWS7ISNo2nTXMn9wBXUPSyf9J7SBjro5wHu8kHrUmIZHodLBHCQ7TVi5pJ5W7
         XdXEEiVZd2jPQRkNY9DRJyMRoJuI0TS2XbgUsd/g1q5J6LzKUgycgZ9/lmS6QPal8e
         AMzP6093LHA/w==
Date:   Thu, 27 Oct 2022 11:05:34 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, chaitanyak@nvidia.com,
        target-devel@vger.kernel.org
Subject: Re: [PATCH v3 07/19] nvme: Don't hardcode the data len for pr
 commands
Message-ID: <Y1q6XsMuS6W1Tz8n@kbusch-mbp.dhcp.thefacebook.com>
References: <20221026231945.6609-1-michael.christie@oracle.com>
 <20221026231945.6609-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221026231945.6609-8-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 26, 2022 at 06:19:33PM -0500, Mike Christie wrote:
> Reservation Report support needs to pass in a variable sized buffer, so
> this patch has the pr command helpers take a data length argument.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Looks good.

Reviewed-by: Keith Busch <kbusch@kernel.org>
