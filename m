From: Dave Wysochanski <davidw@netapp.com>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 23:35:19 -0500
Message-ID: <41E35787.7060003@netapp.com>
References: <41E30855.9050203@cs.wisc.edu> <20050110232442.GB10138@infradead.org> <1105404318.4477.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.netapp.com ([216.240.18.37]:56141 "EHLO mx2.netapp.com")
	by vger.kernel.org with ESMTP id S262349AbVAKEf0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 23:35:26 -0500
In-Reply-To: <1105404318.4477.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:

> On Mon, 2005-01-10 at 23:24 +0000, Christoph Hellwig wrote:
> > Can you kill the ugly iscsi-sfnet name?  We also don't call out 
> networking
> > code ipv4-swansea ;-)  Simple iscsi should be enough, or if you 
> think that's
> > confusing vs driver for hardware offload cards maybe sw-iscsi.
>
> Please not that can of worms again.
>
> For the time being I think iscsi-sfnet will do since there's still one
> other possible linux iscsi stack around.  And we would probably have
> called our networking code ipv4-swansea if we also had an ipv4-bsd or
> something else one could use.
>

What is the other possible iscsi stack?


> In the long run, there will be only a single iscsi driver, and it can be
> renamed as such, but in the short term we're not ready to choose.
>
> James
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
