From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 1/4] [SCSI] ips: remove ips_ha members that duplicate struct pci_dev members
Date: Thu, 25 Oct 2007 10:32:15 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD02@otce2k301.adaptec.com>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234827.74AD61F81A1@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([162.62.93.58]:58456 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754079AbXJYOcR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 10:32:17 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071024234827.74AD61F81A1@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org

ACK. Inspected; Mechanical, precise and no introduction of bugs.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Wednesday, October 24, 2007 7:48 PM
> To: LKML; linux-scsi@vger.kernel.org
> Cc: akpm@linux-foundation.org
> Subject: [PATCH 1/4] [SCSI] ips: remove ips_ha members that 
> duplicate struct pci_dev members
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/ips.c |  178 
> ++++++++++++++++++++++++----------------------------
>  drivers/scsi/ips.h |   20 +++----
>  2 files changed, 91 insertions(+), 107 deletions(-)
