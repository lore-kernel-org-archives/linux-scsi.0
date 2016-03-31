From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 3/3] qla2xxx: Assign names to the flags in cmd_flags
Date: Thu, 31 Mar 2016 08:22:29 -0700
Message-ID: <56FD40B5.4090707@sandisk.com>
References: <56FC6049.3090303@sandisk.com> <56FC6096.30507@sandisk.com>
 <E8740ECF-B45F-4999-83AF-3EA27E4F55DF@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:61628
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755940AbcCaPWf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 11:22:35 -0400
In-Reply-To: <E8740ECF-B45F-4999-83AF-3EA27E4F55DF@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Quinn Tran <quinn.tran@qlogic.com>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Himanshu Madhani <himanshu.madhani@qlogic.com>, Christoph Hellwig <hch@lst.de>, linux-scsi <linux-scsi@vger.kernel.org>

On 03/31/16 08:16, Quinn Tran wrote:
> We use these flags for debugging purpose in crash cases.

Hello Quinn,

It must be inconvenient to have to look up the meaning of the individual 
bits of the cmd_flags variable when analyzing a kernel crash. How about 
preserving all these flags and to assign a meaningful name to each flag 
instead of using bit numbers?

Thanks,

Bart.

