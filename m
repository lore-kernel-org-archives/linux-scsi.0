From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 3/4] [SCSI] ips: PCI API cleanups
Date: Thu, 25 Oct 2007 10:37:38 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD08@otce2k301.adaptec.com>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234830.8F7891F81A9@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:58612 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756215AbXJYOhk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 10:37:40 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071024234830.8F7891F81A9@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org

ACK. Inspected only. Looks ok.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Wednesday, October 24, 2007 7:49 PM
> To: LKML; linux-scsi@vger.kernel.org
> Cc: akpm@linux-foundation.org
> Subject: [PATCH 3/4] [SCSI] ips: PCI API cleanups
> 
> * pass Scsi_Host to ips_remove_device() via pci_set_drvdata(),
>   allowing us to eliminate the ips_ha[] search loop and call
>   ips_release() directly.
> 
> * call pci_{request,release}_regions() and eliminate individual
>   request/release_[mem_]region() calls
> 
> * call pci_disable_device(), paired with pci_enable_device()
> 
> * s/0/NULL/ in a few places
> 
> * check ioremap() return value
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/ips.c |   72 
> ++++++++++++++++++++++-----------------------------
>  1 files changed, 31 insertions(+), 41 deletions(-)
