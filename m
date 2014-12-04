From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH v2 3/5] scsi_debug: add Capacity Changed Unit Attention
Date: Thu, 04 Dec 2014 11:45:44 -0500
Message-ID: <1417711544.3154.247.camel@localhost.localdomain>
References: <54740000.3010104@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932596AbaLDQqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:46:13 -0500
In-Reply-To: <54740000.3010104@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@ORACLE.COM>

On Mon, 2014-11-24 at 23:05 -0500, Douglas Gilbert wrote:
> From: Douglas Gilbert <dgilbert@interlog.com>
> Date: Mon, 24 Nov 2014 20:27:51 -0500
> Subject: [PATCH 3/5] add Capacity Changed Unit Attention
> 
> Via sysfs the virtual_gb scsi_debug parameter can be changed while
> LUs are in use. If that changes, the 'Capacity data has changed'
> Unit Attention is queued on all LUs.
> ---
>   drivers/scsi/scsi_debug.c | 28 ++++++++++++++++++++++++----
>   1 file changed, 24 insertions(+), 4 deletions(-)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

I found a couple of things with this patch that should be
fixed, I'll send patches to correct them, plus a couple of
other changes while I'm at it.

-Ewan

