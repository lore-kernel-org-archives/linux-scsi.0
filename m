From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid: add sysfs support for driver_version
Date: Tue, 19 Jun 2007 16:33:40 -0400
Message-ID: <AE4F746F2AECFC4DA4AADD66A1DFEF01B22E56@otce2k301.adaptec.com>
References: <46783C26.7060908@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gw3.adaptec.com ([216.52.22.36]:35400 "EHLO
	mail-gw3.adaptec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755270AbXFSUdm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Jun 2007 16:33:42 -0400
Content-class: urn:content-classes:message
In-Reply-To: <46783C26.7060908@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Thanks, consider this a NAK for this patch for current tree(s).

Will retain for driver submissions for older 2.6 kernels (SLES9 for
example) that do not have the /sys/module/ tree.

Sincerely -- Mark Salyzyn

> -----Original Message-----
> From: Brian King [mailto:brking@linux.vnet.ibm.com] 
> Sent: Tuesday, June 19, 2007 4:27 PM
> To: Salyzyn, Mark
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [PATCH] aacraid: add sysfs support for driver_version
> 
> 
> Salyzyn, Mark wrote:
> > Adding sysfs support for driver_version.
> 
> This is already available in /sys/module/aacraid/version
> 
> Is this insufficient?
> 
> -Brian
> 
> -- 
> Brian King
> Linux on Power Virtualization
> IBM Linux Technology Center
> 
