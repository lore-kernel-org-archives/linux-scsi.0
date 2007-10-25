From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] iscsi: fix compile error when debug enabled
Date: Thu, 25 Oct 2007 17:05:34 -0500
Message-ID: <4721132E.6080600@cs.wisc.edu>
References: <4720F6CD.1000907@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52410 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751848AbXJYWFl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Oct 2007 18:05:41 -0400
In-Reply-To: <4720F6CD.1000907@cybernetics.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: open-iscsi@googlegroups.com
Cc: linux-scsi@vger.kernel.org

Tony Battersby wrote:
> This patch fixes a compile error in iSCSI when DEBUG_SCSI is defined.
> 

Thanks we have a patch for that in the iscsi tree already.

> Signed-off-by: Tony Battersby <tonyb@cybernetics.com>
> ---
> --- linux-2.6.24-rc1/drivers/scsi/libiscsi.c.orig	2007-10-25 15:56:32.000000000 -0400
> +++ linux-2.6.24-rc1/drivers/scsi/libiscsi.c	2007-10-25 15:56:49.000000000 -0400
> @@ -1058,7 +1058,7 @@ static int iscsi_exec_abort_task(struct 
>  	if (!ctask->mtask) {
>  		spin_unlock_bh(&session->lock);
>  		iscsi_conn_failure(conn, ISCSI_ERR_CONN_FAILED);
> -		spin_lock_bh(&session->lock)
> +		spin_lock_bh(&session->lock);
>  		debug_scsi("abort sent failure [itt 0x%x]\n", ctask->itt);
>  		return -EPERM;
>  	}
> 
> 
> 
> --~--~---------~--~----~------------~-------~--~----~
> You received this message because you are subscribed to the Google Groups "open-iscsi" group.
> To post to this group, send email to open-iscsi@googlegroups.com
> To unsubscribe from this group, send email to open-iscsi-unsubscribe@googlegroups.com
> For more options, visit this group at http://groups.google.com/group/open-iscsi
> -~----------~----~----~----~------~----~------~--~---
> 

