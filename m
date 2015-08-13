From: Manoj Kumar <manoj@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 3/3] cxlflash: Virtual LUN support
Date: Thu, 13 Aug 2015 18:43:28 -0500
Message-ID: <55CD2BA0.6040005@linux.vnet.ibm.com>
References: <1439423476-15687-1-git-send-email-mrochs@linux.vnet.ibm.com> <1439467402.21643.50.camel@neuling.org>
Reply-To: manoj@linux.vnet.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e17.ny.us.ibm.com ([129.33.205.207]:44599 "EHLO
	e17.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752212AbbHMXnb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Aug 2015 19:43:31 -0400
Received: from /spool/local
	by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <manoj@linux.vnet.ibm.com>;
	Thu, 13 Aug 2015 19:43:30 -0400
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
	by d01dlp03.pok.ibm.com (Postfix) with ESMTP id 02F3DC90043
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 19:34:32 -0400 (EDT)
Received: from d01av05.pok.ibm.com (d01av05.pok.ibm.com [9.56.224.195])
	by b01cxnp22034.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id t7DNhQHB59899954
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 23:43:26 GMT
Received: from d01av05.pok.ibm.com (localhost [127.0.0.1])
	by d01av05.pok.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id t7DNhPOi023827
	for <linux-scsi@vger.kernel.org>; Thu, 13 Aug 2015 19:43:26 -0400
In-Reply-To: <1439467402.21643.50.camel@neuling.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Neuling <mikey@neuling.org>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, nab@linux-iscsi.org, brking@linux.vnet.ibm.com, wenxiong@linux.vnet.ibm.com, dja@ozlabs.au.ibm.com, benh@kernel.crashing.org, hch@infradead.org, imunsie@au1.ibm.com

Mikey:

Thanks for your review. See comment inline below.

- Manoj Kumar

On 8/13/2015 7:03 AM, Michael Neuling wrote:
> Thanks for integrating my suggestions.  create_context() has the same
> freeing bug as 2/3 but if you fix that I'm happy if you add my
> reviewed by:
>
> Reviewed-by: Michael Neuling <mikey@neuling.org>

I believe create_context() is in 2/3, not here. I did not find the same
issue in this patch.

