From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: bad error handling in lpfc in 2.6.13
Date: Fri, 07 Oct 2005 08:32:46 +1000
Message-ID: <1128637966.24835.5.camel@gaston>
References: <20051006222400.GA10273@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gate.crashing.org ([63.228.1.57]:9933 "EHLO gate.crashing.org")
	by vger.kernel.org with ESMTP id S1751128AbVJFWeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2005 18:34:13 -0400
In-Reply-To: <20051006222400.GA10273@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org, Olof Johansson <olof@austin.ibm.com>


> 3.91a1 - with the panic below
> 3.93a0 - this did not panic, I got some :
>  Badness in __iommu_free at arch/ppc64/kernel/iommu.c:208

FYI. This looks like dma_free_* is called for something that was not
allocated (bogus values passed)

Ben.


