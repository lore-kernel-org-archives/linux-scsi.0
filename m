Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CEB3C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:06:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D01C4610CC
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 15:06:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232836AbhDTPGn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Apr 2021 11:06:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231682AbhDTPGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Apr 2021 11:06:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF0AB61104;
        Tue, 20 Apr 2021 15:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618931171;
        bh=tqsb4/gk1G/hoskJfjIiAt6lDTs0MSBSeCdqued2VZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uY0oVC1sZHBDnuyxbY3qz1tK8g1dpHqrG91AHasfoSyEm17UD52HKh3ZAutNcnWaA
         1S0puOp28a3cUxGo1SRdQ1nT3vk43eGu1tHazAAOHbaJ/r9EAW1Hygb9Xk6bhmGXXw
         2kWyM8ZqFNN5pq3J7ytGWDJLTZoARaPZ1rVSs7Eo=
Date:   Tue, 20 Apr 2021 17:06:08 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Don Brace <don.brace@microchip.com>
Subject: Re: [PATCH 093/117] staging: Convert to the scsi_status union
Message-ID: <YH7t4DbI0y/sn3hd@kroah.com>
References: <20210420000845.25873-1-bvanassche@acm.org>
 <20210420021402.27678-3-bvanassche@acm.org>
 <YH6HKauLLpJdGqeU@kroah.com>
 <2800d64f-cb58-374b-5d22-321c754bd691@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2800d64f-cb58-374b-5d22-321c754bd691@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 20, 2021 at 08:02:46AM -0700, Bart Van Assche wrote:
> On 4/20/21 12:47 AM, Greg Kroah-Hartman wrote:
> > On Mon, Apr 19, 2021 at 07:13:38PM -0700, Bart Van Assche wrote:
> >> An explanation of the purpose of this patch is available in the patch
> >> "scsi: Introduce the scsi_status union".
> > 
> > Where is that at?
> > 
> > As a stand-alone-patch, this is not ok in a changelog text at all,
> > sorry, and I can not take this.
> 
> Hi Greg,
> 
> That is a reference to an earlier patch in this series. I plan to
> replace the above text with the more elaborate description when I repost
> this patch series. For the current version of this patch series, please
> take a look at
> https://lore.kernel.org/linux-scsi/20210420000845.25873-12-bvanassche@acm.org/T/#u

You should have pointed to the lore.kernel.org link in the commit logs
then, otherwise we have no way of knowing this when I get copied on
patch 93 of a 117 patch series :(

greg k-h
