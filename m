Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16024C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 31 Jan 2022 12:53:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241522AbiAaMx1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 Jan 2022 07:53:27 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34628 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239602AbiAaMx1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Jan 2022 07:53:27 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CCD816117F
        for <linux-scsi@vger.kernel.org>; Mon, 31 Jan 2022 12:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AB3BC340E8;
        Mon, 31 Jan 2022 12:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643633606;
        bh=X6Hn6bhJweNAdCTbuiyIF/aNqapvRDk01vu9XhbqBOs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D1XPjqzUTT8N+p4iWoonrCeu+Jaowz7tkkEcrVcJGE297VvoI0ypiOSR9th2tfvBc
         tuo77X2bRaTmDP6t7UtTpnu9fZdhwVWRJDMNpekGyG/EAs/W+hQmF1Qvp1unE9/zFm
         ameuL4Ug6VuSq+k8BNzHX/E5HQxJxmjrU2vmKpdU=
Date:   Mon, 31 Jan 2022 13:53:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Juergen E. Fischer" <fischer@norbit.de>,
        Russell King <linux@armlinux.org.uk>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Oliver Neukum <oliver@neukum.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 03/44] scsi: Remove drivers/scsi/scsi.h
Message-ID: <Yffbw3soL6rX26OE@kroah.com>
References: <20220128221909.8141-1-bvanassche@acm.org>
 <20220128221909.8141-4-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128221909.8141-4-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jan 28, 2022 at 02:18:28PM -0800, Bart Van Assche wrote:
> The following two header files have the same file name: include/scsi/scsi.h
> and drivers/scsi/scsi.h. This is confusing. Remove the latter since the
> following note was added in drivers/scsi/scsi.h in 2004:
> 
> "NOTE: this file only contains compatibility glue for old drivers. All
> these wrappers will be removed sooner or later. For new code please use
> the interfaces declared in the headers in include/scsi/"
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
