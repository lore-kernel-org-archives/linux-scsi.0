Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50842C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri, 10 Mar 2023 07:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230204AbjCJHN4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 10 Mar 2023 02:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbjCJHNu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Mar 2023 02:13:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F1EC1ABE6;
        Thu,  9 Mar 2023 23:13:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C02DB821C2;
        Fri, 10 Mar 2023 07:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0378C433EF;
        Fri, 10 Mar 2023 07:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678432424;
        bh=mWLH7g2+IPJWbdqPe/Id+tdWHHMndQyV+CGtdI+s6Gg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CIO1H9sPyz6X9uMKt9R2DjECOm7UBwRuvHsiTwEG0tKVxlR6dNtLiRIkFeQRkyt75
         M1NU1WXgO8FL/ssWjmmXFqkBKSU7IVeEcvv+6uEJ5gUR56Zmb8g8ePcRg0uO/UOldt
         /CpMbchRbb9gdaDwX4qSuBfoRTfIYCtDvvUz9Aq4=
Date:   Fri, 10 Mar 2023 08:13:41 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.com>, linux-usb@vger.kernel.org,
        Oliver Neukum <oliver@neukum.org>
Subject: Re: [PATCH v2 81/82] usb: uas: Declare two host templates and host
 template pointers const
Message-ID: <ZArYpc0gktBmlJXz@kroah.com>
References: <20230309192614.2240602-1-bvanassche@acm.org>
 <20230309192614.2240602-82-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230309192614.2240602-82-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2023 at 11:26:13AM -0800, Bart Van Assche wrote:
> Improve source code documentation by constifying host templates that are
> not modified.
> 
> Acked-by: Alan Stern <stern@rowland.harvard.edu> (for usb-storage)
> Acked-by: Oliver Neukum <oneukum@suse.com>
> Cc: Oliver Neukum <oneukum@suse.com>
> Cc: linux-usb@vger.kernel.org
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
