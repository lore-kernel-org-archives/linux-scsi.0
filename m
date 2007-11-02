From: Muli Ben-Yehuda <muli@il.ibm.com>
Subject: Re: [PATCH -mm 0/3] convert IOMMUs to use iova
Date: Fri, 2 Nov 2007 19:12:27 +0200
Message-ID: <20071102171227.GH7975@rhun.haifa.ibm.com>
References: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate7.de.ibm.com ([195.212.29.156]:59945 "EHLO
	mtagate7.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756754AbXKBRMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Nov 2007 13:12:33 -0400
Content-Disposition: inline
In-Reply-To: <bfa0a387d445abb10ae67cf1541a6e20b9c0d31e.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <tomof@acm.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, jens.axboe@oracle.com, jeff@garzik.org, anil.s.keshavamurthy@intel.com, paulus@samba.org, anton@samba.org, olof@lixom.net, tony.luck@intel.com, davem@davemloft.net, kyle@parisc-linux.org, fujita.tomonori@lab.ntt.co.jp

On Sat, Nov 03, 2007 at 02:05:39AM +0900, FUJITA Tomonori wrote:

> This patchset convert the PPC64 IOMMU to use the iova code for free
> area management.
> 
> The IOMMUs ignores low level drivers' restrictions, the maximum
> segment size and segment boundary.
> 
> I fixed the former:
> 
> http://thread.gmane.org/gmane.linux.scsi/35602
> 
> The latter makes the free area management complicated. I'd like to
> convert IOMMUs to use the iova code (that intel-iommu introduced)
> for free area management and enable iova to handle segment boundary
> restrictions, rather than fixing all the IOMMUs' free area
> management,

In general it sounds like a great idea, but have you looked at what
impact this has on the performance of the IO path?

Cheers,
Muli
