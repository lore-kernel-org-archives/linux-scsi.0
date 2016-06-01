From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of
 ->host_failed
Date: Wed, 1 Jun 2016 08:29:47 -0700
Message-ID: <38efc40d-fec9-3278-abb8-2a78c4146a8c@sandisk.com>
References: <1464683898-9877-1-git-send-email-fangwei1@huawei.com>
 <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0094.outbound.protection.outlook.com ([157.56.111.94]:61856
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932597AbcFAP34 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jun 2016 11:29:56 -0400
In-Reply-To: <BF6B9AADDDF11740967545E971C7C0DE6B861A22@MAIL1.pickering.lenbrook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kevin Groeneveld <KGroeneveld@lenbrook.com>, Wei Fang <fangwei1@huawei.com>, "tj@kernel.org" <tj@kernel.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "corbet@lwn.net" <corbet@lwn.net>
Cc: "hch@infradead.org" <hch@infradead.org>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>

On 06/01/2016 07:36 AM, Kevin Groeneveld wrote:
>> Subject: [PATCH v2 1/2] scsi: fix race between simultaneous decrements of ->host_failed
>
> I wonder if this could be related to http://www.spinics.net/lists/linux-scsi/msg86808.html?
>
> I never did get to the bottom of that.  If I have time I hope to retest my scsi hang issue with this patch.

I've never seen that hang with the ib_srp driver (which is a SCSI LLD). 
That probably means that the SATA code uses the SCSI error handler in 
another way than other SCSI LLDs.

Bart.
