From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [patch 02/10] zfcp: Remove SCSI device when removing unit
Date: Tue, 27 Jul 2010 15:37:55 -0500
Message-ID: <1280263075.2833.404.camel@mulgrave.site>
References: <20100716133733.621672000@de.ibm.com>
	 <20100716134300.006377000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51971 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab0G0UiB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Jul 2010 16:38:01 -0400
In-Reply-To: <20100716134300.006377000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com

On Fri, 2010-07-16 at 15:37 +0200, Christof Schmitt wrote:
> plain text document attachment (705-zfcp-unit-removal.diff)
> From: Christof Schmitt <christof.schmitt@de.ibm.com>
> 
> Configuring a LUN in zfcp, also creates a SCSI device. For
> consistency, it makes sense to remove the SCSI device when the LUN is
> deconfigured. Replace the flush_work with the call to
> scsi_remove_device: scsi_remove_device also takes the scan_mutex that
> synchronizes itself with any long running device discovery.

This one's rejecting:

jejb@mulgrave:~/git/scsi-misc-2.6> patch -p1 < ~/tmp/tmp/02
patching file drivers/s390/scsi/zfcp_def.h
patching file drivers/s390/scsi/zfcp_scsi.c
Hunk #1 FAILED at 564.
1 out of 1 hunk FAILED -- saving rejects to file
drivers/s390/scsi/zfcp_scsi.c.rej

It looks like a missing patch somewhere.

Could you check the current state of scsi-misc-2.6 (it includes
scsi-rc-fixes-2.6) and see if I've lost something?

Thanks,

James


