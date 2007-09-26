From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: [PATCH 0/5] fix iommu sg list merge problem
Date: Wed, 26 Sep 2007 23:48:48 +0900
Message-ID: <20070925201447C.tomof@acm.org>
References: <20070926100221.GW4239@rhun.haifa.ibm.com>
	<20070925200025O.tomof@acm.org>
	<1190817512.3359.16.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:48215 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750872AbXIZOtl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Sep 2007 10:49:41 -0400
In-Reply-To: <1190817512.3359.16.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com
Cc: tomof@acm.org, muli@il.ibm.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 26 Sep 2007 09:38:32 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Wed, 2007-09-26 at 23:34 +0900, FUJITA Tomonori wrote:
> > Yeah, I thought about it and it's possible (but not so easy). parisc
> > has IOMMU merging helper code and two parisc IOMMUs use it. ia64
> > sba_iommu is almost identical to parisc code. x86_64 gart, power, and
> > alpha do in their own way. But I think that we can merging helper code
> > useful for all.
> 
> Er ... it should be identical ... the SBA iommu is the same ... I
> thought we moved the common code out to a shared file.

2.6.23-rc8-mm1 has two iommu_coalesce_chunks in
drivers/iommu-helpers.h and arch/ioa64/hp/common/sb_iommu.c

iommu_coalesce_chunks are almost same. parisc's iommu_coalesce_chunks
is simpler a bit.
