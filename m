From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() failure, and other err cleanups
Date: Thu, 25 Oct 2007 10:39:45 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01F3DD0A@otce2k301.adaptec.com>
References: <09821349085390234lkjasdflkjasflkdj24746@havoc.gtf.org> <20071024234832.58C3B1F81AB@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ts.adaptec.com ([162.62.93.58]:58646 "EHLO mail-gw3.adaptec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754153AbXJYOjr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 25 Oct 2007 10:39:47 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20071024234832.58C3B1F81AB@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
Cc: akpm@linux-foundation.org

ACK. Inspected. cleanup with zero risk.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org 
> [mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Jeff Garzik
> Sent: Wednesday, October 24, 2007 7:49 PM
> To: LKML; linux-scsi@vger.kernel.org
> Cc: akpm@linux-foundation.org
> Subject: [PATCH 4/4] [SCSI] ips: handle scsi_add_host() 
> failure, and other err cleanups
> 
> Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
> ---
>  drivers/scsi/ips.c |   18 +++++++++++++-----
>  1 files changed, 13 insertions(+), 5 deletions(-)
