From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_debug: fix compare and write errors
Date: Thu, 04 Dec 2014 11:43:42 -0500
Message-ID: <1417711422.3154.245.camel@localhost.localdomain>
References: <547611A9.2040208@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53933 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092AbaLDQoN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:44:13 -0500
In-Reply-To: <547611A9.2040208@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@infradead.org>, Dan Carpenter <dan.carpenter@oracle.com>, Hannes Reinecke <hare@suse.de>

On Wed, 2014-11-26 at 12:45 -0500, Douglas Gilbert wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> Date: Wed, 26 Nov 2014 12:33:48 -0500
> Subject: [PATCH] scsi_debug fix compare and write errors
> 
> Kernel build tools pointed out a memory leak so that has been
> fixed and its error paths strengthened with a goto. Testing
> showed compare and write was only working for lba=0; correcting
> the length of the LBA field fixed that.
> ---
>   drivers/scsi/scsi_debug.c | 31 ++++++++++++++++---------------
>   1 file changed, 16 insertions(+), 15 deletions(-)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Looks fine to me.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


