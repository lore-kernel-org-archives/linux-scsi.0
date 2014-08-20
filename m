From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH/RESEND] scsi.mq: Added use_cmd_list flag in scsi_host to reduce lock contention
Date: Wed, 20 Aug 2014 11:47:02 -0400
Message-ID: <yq1sikrtb7t.fsf@sermon.lab.mkp.net>
References: <201408201357.s7KDvDeL021549@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47541 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTPro (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Aug 2014 11:47:44 -0400
In-Reply-To: <201408201357.s7KDvDeL021549@palmhbs0.lsi.com> (Kashyap Desai's
	message of "Wed, 20 Aug 2014 19:24:33 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap.Desai@avagotech.com
Cc: linux-scsi@vger.kernel.org, hch@infradead.org, elliott@hp.com, jbottomley@parallels.com, aacraid@adaptec.com, bvanassche@acm.org

>>>>> "Kashyap" ==   <Kashyap.Desai@avagotech.com> writes:

Kashyap> Comment provided by Bart Van and Chris H is addressed in this
Kashyap> patch.  Add use_cmd_list flag in scsi_host to indicate scs.mq
Kashyap> stack to keep track of cmd_list per sdev.

Kashyap> Default behaviour is not to keep track of cmd_list per sdev, as
Kashyap> this may introduce lock contention. (overhead is more on
Kashyap> multi-node NUMA.)

Kashyap> Patch is tested using megaraid_sas driver with "use_cmd_list"
Kashyap> value set to 1 and 0.  Added MAINTAINER of Adaptec to verify
Kashyap> changes.

Kashyap> Signed-off-by: Kashyap Desai <kashyap.desai@avagotech.com>

Looks good to me.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
