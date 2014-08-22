From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH/RESEND] scsi.mq: Added use_cmd_list flag in scsi_host
 to reduce lock contention
Date: Fri, 22 Aug 2014 18:04:17 +0200
Message-ID: <53F76A01.7060806@acm.org>
References: <201408201357.s7KDvDeL021549@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf2.bxl.stone.is ([5.134.1.239]:41791 "EHLO sf2.bxl.stone.is"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932098AbaHVQEq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Aug 2014 12:04:46 -0400
In-Reply-To: <201408201357.s7KDvDeL021549@palmhbs0.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap.Desai@avagotech.com, linux-scsi@vger.kernel.org, hch@infradead.org, elliott@hp.com, jbottomley@parallels.com, aacraid@adaptec.com

On 08/20/14 15:54, Kashyap.Desai@avagotech.com wrote:
> Comment provided by Bart Van and Chris H is addressed in this patch.
> 
> Add use_cmd_list flag in scsi_host to indicate scs.mq stack
> to keep track of cmd_list per sdev. 
> 
> Default behaviour is not to keep track of cmd_list per sdev, as this may introduce
> lock contention. (overhead is more on multi-node NUMA.)
> 
> Patch is tested using megaraid_sas driver with "use_cmd_list" value set to 1 and 0.
> Added MAINTAINER of Adaptec to verify changes.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

