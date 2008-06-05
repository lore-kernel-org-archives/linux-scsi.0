From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: Intel IOMMU (and IOMMU for Virtualization) performances
Date: Thu, 5 Jun 2008 23:49:11 +0900
Message-ID: <20080605231914Z.fujita.tomonori@lab.ntt.co.jp>
References: <20080604235053K.fujita.tomonori@lab.ntt.co.jp>
	<873antuojg.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:32908 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928AbYFEOtY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Jun 2008 10:49:24 -0400
In-Reply-To: <873antuojg.fsf@basil.nowhere.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andi@firstfloor.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-kernel@vger.kernel.org, mgross@linux.intel.com, linux-scsi@vger.kernel.org

On Wed, 04 Jun 2008 18:56:35 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp> writes:
> >
> > I'm just interested in other people's opinions on IOMMU
> > implementations, performances, possible future changes for performance
> > improvement, etc.
> 
> I think using the bitmap is an excellent idea and your numbers look good. 
> Do you have numbers on the memory consumption too?
> Trading some memory for performance is ok for something as performance critical 
> as the IOMMU. 

If we use 4GB virtual DMA address space (as the patch does), we need
128 KB for the bitmap for one domain.

With the RB tree, the memory consumption depends on how many addresses
are mapped (it needs one entry for one address though we could merge
multiple addresses).
