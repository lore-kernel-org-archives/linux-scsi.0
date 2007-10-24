From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH -mm 11/11] aacraid: use pci_set_dma_max_seg_size
Date: Thu, 25 Oct 2007 01:21:31 +0900
Message-ID: <20071025012348Z.tomof@acm.org>
References: <67bb10d9f4e9473ddc84d9839114602c1966f19f.tomof@acm.org>
	<20071024173019I.tomof@acm.org>
	<AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB4@otce2k301.adaptec.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:60388 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295AbXJXQWi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Oct 2007 12:22:38 -0400
In-Reply-To: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DAB4@otce2k301.adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mark_salyzyn@adaptec.com
Cc: tomof@acm.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com, aacraid@adaptec.com, fujita.tomonori@lab.ntt.co.jp

On Wed, 24 Oct 2007 09:34:23 -0400
"Salyzyn, Mark" <mark_salyzyn@adaptec.com> wrote:

> ACK

Thanks.

> Based on the presence of the call. 2.6.22, for instance, does not have
> this capability...
> 
> I did not test this change, just accepting on the principals. How much
> testing of the change did you do Fujita?

Unfortunately, I tested only the main component (device and pci
changes) with ppc64 IOMMU. I don't have the other IOMMUs.

I didn't test the aacraid patch but I guess that I have aacraid in the
workplace so I can test the patch (without the IOMMU chages).
