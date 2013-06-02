From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity
 support
Date: Sun, 02 Jun 2013 12:16:47 -0400
Message-ID: <51AB6FEF.5000701@interlog.com>
References: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:32851 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab3FBQRA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Jun 2013 12:17:00 -0400
In-Reply-To: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-scsi@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 13-05-26 04:01 AM, Akinobu Mita wrote:
> This patch set includes bug fixes which I hit when I was tried testing
> the data integrity support in scsi_debug on x86_32.
>
> And it also includes cleanups which helps increasing readability and
> further bug fixing in data integrity support.
>
> * Changes from v2
> - Add new bug fix patch for UNMAP command support
> - Change the way to fix for the patch "fix invalid address passed to
>    kunmap_atomic()"
> - Reduce more lines of code for the patch "reduce duplication between
>    prot_verify_read and prot_verify_writ"
>
> * Changes from v1
> - Split the patch "fix data integrity support on highmem machine" into
>    two separate patches.
> - Add new cleanup patch "reduce duplication between prot_verify_read and
>    prot_verify_write".
>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
>
> Akinobu Mita (6):
>    scsi_debug: fix invalid address passed to kunmap_atomic()
>    scsi_debug: fix incorrectly nested kmap_atomic()
>    scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
>    scsi_debug: invalidate protection info for unmapped region
>    scsi_debug: simplify offset calculation for dif_storep
>    scsi_debug: reduce duplication between prot_verify_read and
>      prot_verify_write
>
>   drivers/scsi/scsi_debug.c | 176 +++++++++++++++++++---------------------------
>   1 file changed, 72 insertions(+), 104 deletions(-)

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

