From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: restart list search after unlock in
 scsi_remove_target
Date: Mon, 19 Oct 2015 09:01:31 -0700
Message-ID: <1445270491.2188.23.camel@HansenPartnership.com>
References: <20151019143546.GA7486@lst.de> <56250DF7.6050803@sandisk.com>
	 <20151019155658.GA11453@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47768 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750814AbbJSQBd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Oct 2015 12:01:33 -0400
In-Reply-To: <20151019155658.GA11453@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org, jthumshirn@suse.de, Dan Williams <dan.j.williams@intel.com>

On Mon, 2015-10-19 at 17:56 +0200, Christoph Hellwig wrote:
> On Mon, Oct 19, 2015 at 08:36:23AM -0700, Bart Van Assche wrote:
> > Thanks for looking into this. However, I think we need a motivation in the 
> > patch description why this patch does not reintroduce the soft lockup 
> > documented in patch "scsi_remove_target: fix softlockup regression on hot 
> > remove" (commit bc3f02a795d3).
> 
> Interesting.  I tried to find the original report and what state
> changes would cause an endless loop here.

The original report is this one:

http://thread.gmane.org/gmane.linux.kernel/1348679

James

>   Dan, do you remember any
> details about this bug report?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



