From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 5/5] lpfc : Make Emulex lpfc driver legacy I/O port free
Date: Wed, 03 Jan 2007 16:06:48 -0600
Message-ID: <1167862008.2789.81.camel@mulgrave.il.steeleye.com>
References: <4564051C.3080908@jp.fujitsu.com>  <4564706E.9060900@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:52225 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751009AbXACWG7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jan 2007 17:06:59 -0500
In-Reply-To: <4564706E.9060900@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-pci@atrey.karlin.mff.cuni.cz, Greg KH <greg@kroah.com>, Grant Grundler <grundler@parisc-linux.org>, Andrew Morton <akpm@osdl.org>, e1000-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

On Wed, 2006-11-22 at 10:44 -0500, James Smart wrote:
> ACK  :)
> 
> (I thought this had already gone in a while ago)

Actually, there seems to be missing infrastructure for this:

  CC [M]  drivers/scsi/lpfc/lpfc_init.o
drivers/scsi/lpfc/lpfc_init.c: In function 'lpfc_pci_probe_one':
drivers/scsi/lpfc/lpfc_init.c:1418: warning: implicit declaration of function 'pci_select_bars'
drivers/scsi/lpfc/lpfc_init.c:1422: warning: implicit declaration of function 'pci_request_selected_regions'
drivers/scsi/lpfc/lpfc_init.c:1734: warning: implicit declaration of function 'pci_release_selected_regions'

Is there any ETA on the rest of the infrastructure?

James


