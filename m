From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: [PATCH 4/10][RFC] linux-iscsi driver
Date: Mon, 10 Jan 2005 17:09:19 -0800
Message-ID: <41E3273F.10004@us.ibm.com>
References: <41E30855.9050203@cs.wisc.edu> <20050110232442.GB10138@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:46002 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S262644AbVAKBJb
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Jan 2005 20:09:31 -0500
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j0B19PFJ728862
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 20:09:25 -0500
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j0B19PnX401810
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 18:09:25 -0700
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id j0B19O7M031076
	for <linux-scsi@vger.kernel.org>; Mon, 10 Jan 2005 18:09:24 -0700
In-Reply-To: <20050110232442.GB10138@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, linux-scsi@vger.kernel.org

Christoph Hellwig wrote:
> On Mon, Jan 10, 2005 at 02:57:25PM -0800, Mike Christie wrote:
> 
>>Core iSCSI session code.
> 
> 
> Can you kill the ugly iscsi-sfnet name?  We also don't call out networking
> code ipv4-swansea ;-)  Simple iscsi should be enough, or if you think that's
> confusing vs driver for hardware offload cards maybe sw-iscsi.

That was on my todo. I like iscsi. I think iscsi-sfnet actually stood 
for somthting about sourceforge. I do not know for sure though.

> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


