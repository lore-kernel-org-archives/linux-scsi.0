From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [RFC/PATCH v3] powerpc/iommu: Support "hybrid" iommu/direct DMA
 ops for coherent_mask < dma_mask
Date: Fri, 15 May 2015 17:19:52 -0500
Message-ID: <55567108.7020601@linux.vnet.ibm.com>
References: <555279A8.6060906@linux.vnet.ibm.com> <2214146.EzgWBA6g23@wuerfel> <5553505D.50102@linux.vnet.ibm.com> <10045033.4fV0qQU90u@wuerfel> <55535BDF.6020502@linux.vnet.ibm.com> <CAK=zhgoXx4HJfpTuNAP0tAPnsU8BLmM7X3qGsFCzJfHOx55YCQ@mail.gmail.com> <1431550613.20218.88.camel@kernel.crashing.org> <5553C428.5090806@linux.vnet.ibm.com> <1431641034.4160.71.camel@kernel.crashing.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:54247 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946101AbbEOWT5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 May 2015 18:19:57 -0400
Received: from /spool/local
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Fri, 15 May 2015 16:19:57 -0600
Received: from b03cxnp07028.gho.boulder.ibm.com (b03cxnp07028.gho.boulder.ibm.com [9.17.130.15])
	by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id D3FAB1FF0023
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 16:11:04 -0600 (MDT)
Received: from d03av05.boulder.ibm.com (d03av05.boulder.ibm.com [9.17.195.85])
	by b03cxnp07028.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t4FMHmDN35717146
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 15:17:48 -0700
Received: from d03av05.boulder.ibm.com (localhost [127.0.0.1])
	by d03av05.boulder.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t4FMJrgT030421
	for <linux-scsi@vger.kernel.org>; Fri, 15 May 2015 16:19:54 -0600
In-Reply-To: <1431641034.4160.71.camel@kernel.crashing.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org, Daniel Kreling <kreling@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 05/14/2015 05:03 PM, Benjamin Herrenschmidt wrote:
> This patch adds the ability to the DMA direct ops to fallback to the IOMMU
> ops for coherent alloc/free if the coherent mask of the device isn't
> suitable for accessing the direct DMA space and the device also happens
> to have an active IOMMU table.
> 
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> ---
> 

Thanks. This one works fine for me with mpt2sas.

Tested-by: Brian King <brking@linux.vnet.ibm.com>

-Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


