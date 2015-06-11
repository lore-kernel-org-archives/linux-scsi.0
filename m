From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: [PATCH v6] cxlflash: Base support for IBM CXL Flash Adapter
Date: Thu, 11 Jun 2015 13:15:34 -0500
Message-ID: <5579D046.8070004@linux.vnet.ibm.com>
References: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e19.ny.us.ibm.com ([129.33.205.209]:52706 "EHLO
	e19.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821AbbFKSPz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Jun 2015 14:15:55 -0400
Received: from /spool/local
	by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <brking@linux.vnet.ibm.com>;
	Thu, 11 Jun 2015 14:15:50 -0400
Received: from b01cxnp22036.gho.pok.ibm.com (b01cxnp22036.gho.pok.ibm.com [9.57.198.26])
	by d01dlp01.pok.ibm.com (Postfix) with ESMTP id 5CD3D38C8039
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 14:15:47 -0400 (EDT)
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by b01cxnp22036.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t5BIFl0t59310286
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 18:15:47 GMT
Received: from d01av01.pok.ibm.com (localhost [127.0.0.1])
	by d01av01.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t5BIFhcA015479
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jun 2015 14:15:45 -0400
In-Reply-To: <1433888152-7360-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, nab@linux-iscsi.org, hch@infradead.org, mikey@neuling.org, imunsie@au1.ibm.com, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, mpe@ellerman.id.au

On 06/09/2015 05:15 PM, Matthew R. Ochs wrote:
> SCSI device driver to support filesystem access on the IBM CXL Flash adapter.
> 
> Supported-by: Stephen Bates <stephen.bates@pmcs.com>
> Reviewed-by: Michael Neuling <mikey@neuling.org>
> Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
Reviewed-by: Brian King <brking@linux.vnet.ibm.com>

Hi James,

This driver is dependent on a bunch of core cxl support going in the powerpc
tree. Are you OK with this going through the powerpc tree so they
can both go in a single pull request to Linus?

Are there any additional discussion points or issues you think need to be resolved before
that happens, or should Michael look at queuing this up for -next?

Thanks,

Brian

-- 
Brian King
Power Linux I/O
IBM Linux Technology Center


