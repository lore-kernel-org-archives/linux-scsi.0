From: Kleber Sacilotto de Souza <klebers@linux.vnet.ibm.com>
Subject: Re: [GIT PATCH] SCSI fixes for 2.6.32-rc8
Date: Tue, 01 Dec 2009 14:54:18 -0200
Message-ID: <1259686458.6482.14.camel@zeppelin>
References: <1259620194.11762.137.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:46784 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753841AbZLAQyQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Dec 2009 11:54:16 -0500
Received: from mailhub3.br.ibm.com (mailhub3.br.ibm.com [9.18.232.110])
	by e24smtp01.br.ibm.com (8.14.3/8.13.1) with ESMTP id nB1H7IAX031641
	for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2009 15:07:18 -0200
Received: from d24av01.br.ibm.com (d24av01.br.ibm.com [9.8.31.91])
	by mailhub3.br.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id nB1GtokB2314380
	for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2009 14:55:50 -0200
Received: from d24av01.br.ibm.com (loopback [127.0.0.1])
	by d24av01.br.ibm.com (8.14.3/8.13.1/NCO v10.0 AVout) with ESMTP id nB1G2ouk027912
	for <linux-scsi@vger.kernel.org>; Tue, 1 Dec 2009 14:02:50 -0200
In-Reply-To: <1259620194.11762.137.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Mon, 2009-11-30 at 17:29 -0500, James Bottomley wrote:
> This is a set of miscellaneous (but small) fixes for SCSI.
> 
> The patch is available here:
> 
> master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git
> 
> The short changelog is:
> 
> Alexey Kuznetsov (1):
>       fix crash when disconnecting usb storage
> 
> James Bottomley (1):
>       fix async scan add/remove race resulting in an oops
> 
> Martin K. Petersen (1):
>       sd: Return correct error code for DIF
> 
> The diffstat is:
> 
>  drivers/scsi/hosts.c       |    2 -
>  drivers/scsi/scsi_scan.c   |   18 ++----------
>  drivers/scsi/scsi_sysfs.c  |   63 +++++++++++++++++++--------------------------
>  drivers/scsi/sd_dif.c      |    2 -
>  include/scsi/scsi_device.h |    1 
>  5 files changed, 34 insertions(+), 52 deletions(-)

Can you please add the patch from "[PATCH] ipr: fix EEH recovery" sent
to this list?


Thanks,
Kleber


-- 
Kleber S. Souza
IBM Linux Technology Center

