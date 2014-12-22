From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH] scsi_debug: fix sanity check in resp_rsup_opcodes
Date: Mon, 22 Dec 2014 12:13:00 -0500
Message-ID: <1419268380.3853.128.camel@localhost.localdomain>
References: <549848BD.6060402@interlog.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754841AbaLVRNb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2014 12:13:31 -0500
In-Reply-To: <549848BD.6060402@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: SCSI development list <linux-scsi@vger.kernel.org>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, dcb314@hotmail.com

On Mon, 2014-12-22 at 11:37 -0500, Douglas Gilbert wrote:
> David Binderman pointed out in this post:
> 
> http://marc.info/?l=linux-scsi&m=141924469523474&w=2
> 
> a sanity check that was flawed. See attached fix. Should
> be applied to lk 3.19.0-rc1 and Christoph's branches.
> 
> ChangeLog:
>      fix alloc_len sanity check in resp_rsup_opcodes()
> 
> 
> ---
>   drivers/scsi/scsi_debug.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


