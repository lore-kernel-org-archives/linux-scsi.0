From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: self assignment bug in aix94xx
Date: Thu, 24 Oct 2013 10:03:10 +0100
Message-ID: <1382605390.2559.12.camel@dabdike.quadriga.com>
References: <20131024085512.GB15720@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56009 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752036Ab3JXJDO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Oct 2013 05:03:14 -0400
In-Reply-To: <20131024085512.GB15720@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-10-24 at 04:55 -0400, Dave Jones wrote:
> 2908d778        (James Bottomley        2006-08-29 09:22:51 -0500       515)    scb->ssp_task.retry_count = scb->ssp_task.retry_count;
> 
> Is this supposed to maybe be..
> 
> 	scb->ssp_task.retry_count = task->ssp_task.retry_count;
> 
> ?

Oh, boy, this was the master commit for aic94xx (so it's not me it was a
bunch of people working on the driver).  I'll see if I can analyse the
logic flow to find out what should have been going on, but it will take
a couple of weeks.

> (This and a whole bunch of similar bugs found with Coverity.)

May as well send them along and I'll look at them too.

James

> 	Dave
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



