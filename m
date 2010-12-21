From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 0/11]: Update megaraid_sas driver explanation
Date: Tue, 21 Dec 2010 15:26:20 -0500
Message-ID: <20101221202620.GA15750@infradead.org>
References: <AANLkTi=xOBgxZ8eJuYbKUAjHQ-uC1rr-qdU8UT-vMt9H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:52590 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LUU0W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Dec 2010 15:26:22 -0500
Content-Disposition: inline
In-Reply-To: <AANLkTi=xOBgxZ8eJuYbKUAjHQ-uC1rr-qdU8UT-vMt9H@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: adam radford <aradford@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "bo.yang" <bo.yang@lsi.com>

On Tue, Dec 14, 2010 at 06:40:18PM -0800, adam radford wrote:
> James/linux-scsi,
> 
> Please ignore the previous megaraid_sas patches 1 thru 9 from Bo Yang.
>  They will be re-submitted at a later time.
> 
> The following patches update the megaraid_sas driver as follows:
> 
> 1. Rename megaraid_sas.c to megaraid_sas_base.c
> 2. Update GPL headers.
> 3. Add MSI-X support and 'msix_disable' module parameter.
> 4. Use lowest memory bar (for SR-IOV VF support).
> 5. Add struct megasas_instance_template changes, and change all code to use new
>    instance entries:

So what's the actual shared code with older megaraid_sas adapters after
this?  It looks to me like you should simply add another driver for the
new hardware.

