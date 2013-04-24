From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 0/3] scsi_debug: fix data integrity support
Date: Wed, 24 Apr 2013 19:42:57 -0400
Message-ID: <51786E01.9090101@interlog.com>
References: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:33155 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932099Ab3DXXnM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 19:43:12 -0400
In-Reply-To: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 13-04-21 05:17 AM, Akinobu Mita wrote:
> When I tried testing the data integrity support in scsi_debug on x86_32,
> I got CONFIG_DEBUG_HIGHMEM warnings and protection errors.  This was
> triggered due to misused kmap_atomic/kunmap_atomic.
>
> And then, while I was testing the fix of the above issue with several
> combination with module parameters dix and dif, I found that doing
> 'modprobe scsi_debug dif=0 dix=1' causes kernel crash.
>
> This patch set includes these fixes and cleanup which is related to data
> integrity support.
>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
>
> Akinobu Mita (3):
>    scsi_debug: fix data integrity support on highmem machine
>    scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
>    scsi_debug: simplify offset calculation for dif_storep
>
>   drivers/scsi/scsi_debug.c | 29 ++++++++++++-----------------
>   1 file changed, 12 insertions(+), 17 deletions(-)

Again, I'd like to see some feedback from Martin Petersen
on this set of patches. For my part, for this patch series
(1/3 to 3/3):

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

