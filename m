From: Jeff Garzik <jeff@garzik.org>
Subject: Re: What's left in libata-dev.git?
Date: Thu, 25 Oct 2007 05:59:21 -0400
Message-ID: <472068F9.3070700@garzik.org>
References: <472067FD.3060400@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:49324 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536AbXJYJ7X (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 05:59:23 -0400
In-Reply-To: <472067FD.3060400@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: IDE/ATA development list <linux-ide@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Tejun Heo <htejun@gmail.com>, Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, Alan <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Kristen Carlson Accardi <kristen.c.accardi@intel.com>, Jason Gaston <jason.d.gaston@intel.com>

Jeff Garzik wrote:
> Active libata branches:
>   ALL            Superset branch for -mm testing
>   alpm            Link power management (2.6.24-rc hopefully)
>   an            Async notify (2.6.24-rc hopefully)
>   for-testing        Interesting-but-not-ready stuff
>   master        Vanilla linux-2.6.git clone
>   mv-ahci-pata        Marvell 6141 PATA support (incomplete)
>   mv-ncq        sata_mv NCQ support (incomplete)
>   new-eh        sata_qstore, sata_sx4 new-EH conversions
>             (TEST ME! they have been in -mm for a while)
>   pmask            proto_mask introduction
>   sii-lbt        sata_sil large block transfer enablement
>   upstream        pending for 2.6.24-rc
>   upstream-linus    just pushed upstream for 2.6.24-rc


FWIW, current contents of ALL meta-branch:

	upstream
	an
	alpm
	for-testing
	new-eh

i.e. that is what akpm will get on his next pull for -mm.

