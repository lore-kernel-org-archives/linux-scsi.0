From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 0/5] fix iommu sg list merge problem
Date: Wed, 26 Sep 2007 09:38:32 -0500
Message-ID: <1190817512.3359.16.camel@localhost.localdomain>
References: <20070925142141N.tomof@acm.org>
	 <20070926100221.GW4239@rhun.haifa.ibm.com>  <20070925200025O.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60107 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753491AbXIZOie (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Sep 2007 10:38:34 -0400
In-Reply-To: <20070925200025O.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: muli@il.ibm.com, jens.axboe@oracle.com, hch@infradead.org, jeff@garzik.org, gregkh@suse.de, hare@suse.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Wed, 2007-09-26 at 23:34 +0900, FUJITA Tomonori wrote:
> Yeah, I thought about it and it's possible (but not so easy). parisc
> has IOMMU merging helper code and two parisc IOMMUs use it. ia64
> sba_iommu is almost identical to parisc code. x86_64 gart, power, and
> alpha do in their own way. But I think that we can merging helper code
> useful for all.

Er ... it should be identical ... the SBA iommu is the same ... I
thought we moved the common code out to a shared file.

James


