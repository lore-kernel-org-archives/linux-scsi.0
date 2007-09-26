From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH 0/5] fix iommu sg list merge problem
Date: Wed, 26 Sep 2007 12:02:21 +0200
Message-ID: <20070926100221.GW4239@rhun.haifa.ibm.com>
References: <20070925142141N.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:18278 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753608AbXIZKC2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 06:02:28 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.13.8/8.13.8) with ESMTP id l8QA2O3L080790
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2007 10:02:24 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v8.5) with ESMTP id l8QA2OPx2277614
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2007 12:02:24 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l8QA2MVg005494
	for <linux-scsi@vger.kernel.org>; Wed, 26 Sep 2007 12:02:23 +0200
Content-Disposition: inline
In-Reply-To: <20070925142141N.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: James.Bottomley@SteelEye.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, Sep 26, 2007 at 05:57:57PM +0900, FUJITA Tomonori wrote:

> iommu code merges sg lists without considering lld's restrictions so
> some llds need a workaround to split sg lists again. This patchset
> fixes iommu to handle lld's max segment size limit properly.

The patches look reasonable to me.

> This patchset includes only the x86_64 iommu patch

There are multiple x86-64 IOMMUs, but only GART is in-tree and
supports merging.

> but my git tree includes x86_64, ppc, ia64, parisc, and alpha
> patches. As far as I know, thye are all the iommu code that merges
> sg lists. The iommu patchse are only compile tested.
> 
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tomo/linux-2.6-bidi.git iommu

Do you think it will be possible to abstract the merging code into
common code, rather than duplicating it for every IOMMU?

Cheers,
Muli
