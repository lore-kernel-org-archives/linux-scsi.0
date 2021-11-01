Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9BD4C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 17:54:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9B93610E8
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 17:54:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231168AbhKAR4p (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 13:56:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:37650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229802AbhKAR4p (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Nov 2021 13:56:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00C82610D2;
        Mon,  1 Nov 2021 17:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635789251;
        bh=lYi2aGJ1ooV9VTgAd9ni2Aq8I8gmC2AMQ2WBvVmGyXo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=USAxOoUpoPthTp0gPLaP0Dmz+IrOklnbz3hxfaINU34HdN1KKLosqti5cOqQYAaqx
         vAzwAmlRKJCS4A+x3oMJQC9AcOKtiJT2KoUaJ4cme5I1NotGS1dDN/bvui3u93bbcE
         B3Rn9jI2etOBKHaGzpWpNSKH8+DKvAoPRJRFBtf6N1zm28ciWQseguItfGTE8S5SGE
         gJyHvhjcrWhkpnG1mmJggGByc6GpS8LMJMtHSKeqjbFpDR5Mxh0w5yTRZEV8GrOCxe
         BxgY+sBpcZee82y2ujQ1VYBu2NSTbwyTRob4gcnvVGQ+X4+T1CrWDHjF0DwblF8aJB
         gzM9v7RS/EqpQ==
Date:   Mon, 1 Nov 2021 10:54:09 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Hannes Reinecke <hare@suse.de>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "lsf-pc@lists.linux-foundation.org" 
        <lsf-pc@lists.linux-foundation.org>
Subject: Re: [LSF/MM/BFP ATTEND] [LSF/MM/BFP TOPIC] Storage: Copy Offload
Message-ID: <20211101175409.GA2651512@dhcp-10-100-145-180.wdc.com>
References: <PH0PR04MB74161CD0BD15882BBD8838AB9B529@PH0PR04MB7416.namprd04.prod.outlook.com>
 <CGME20210928191342eucas1p23448dcd51b23495fa67cdc017e77435c@eucas1p2.samsung.com>
 <20210928191340.dcoj7qrclpudtjbo@mpHalley.domain_not_set.invalid>
 <c2d0dff9-ad6d-c32b-f439-00b7ee955d69@acm.org>
 <20211006100523.7xrr3qpwtby3bw3a@mpHalley.domain_not_set.invalid>
 <fbe69cc0-36ea-c096-d247-f201bad979f4@acm.org>
 <20211008064925.oyjxbmngghr2yovr@mpHalley.local>
 <2a65e231-11dd-d5cc-c330-90314f6a8eae@nvidia.com>
 <ba6c099b-42bf-4c7d-a923-00e7758fc835@suse.de>
 <5edcab45-afc6-3766-cede-f859da2934d1@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5edcab45-afc6-3766-cede-f859da2934d1@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 29, 2021 at 09:15:43AM -0700, Bart Van Assche wrote:
> On 10/28/21 10:51 PM, Hannes Reinecke wrote:
> > Also Keith presented his work on a simple zone-based remapping block device, which included an in-kernel copy offload facility.
> > Idea is to lift that as a standalone patch such that we can use it a fallback (ie software) implementation if no other copy offload mechanism is available.
> 
> Is a link to the presentation available?

Thanks for the interest.

I didn't post them online as the conference didn't provide it, and I
don't think the slides would be particularly interesting without the
prepared speech anyway.

The presentation described a simple prototype implementing a redirection
table on zone block devices. There was one bullet point explaining how a
generic kernel implementation would be an improvement. For zoned block
devices, an "append" like copy offload would be an even better option.
