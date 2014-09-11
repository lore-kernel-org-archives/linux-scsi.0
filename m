From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Wed, 10 Sep 2014 20:07:47 -0400
Message-ID: <yq1bnqn9fzg.fsf@sermon.lab.mkp.net>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>
	<1409254292-2540-15-git-send-email-martin.petersen@oracle.com>
	<540390FF.2040703@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51382 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733AbaIKAH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Sep 2014 20:07:59 -0400
In-Reply-To: <540390FF.2040703@dev.mellanox.co.il> (Sagi Grimberg's message of
	"Mon, 01 Sep 2014 00:17:51 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, axboe@fb.com, hch@lst.de, sagig@mellanox.com

>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:

[Back from vacation]

>> + [SCSI_PROT_WRITE_PASS] = SCSI_PROT_TRANSFER_PI |
>> + SCSI_PROT_GUARD_CHECK |
>> + SCSI_PROT_REF_CHECK |
>> + SCSI_PROT_REF_INCREMENT |
>> + SCSI_PROT_IP_CHECKSUM,

Sagi> A bit strange to me that you put REF_CHECK & REF_INCREMENT flag
Sagi> depending on the prot_op while it really depends on the prot_type.

It doesn't just depend on the prot_type. You need to be able to tell the
HBA to increment/test the ref tag even for a Type 0 device.

Sagi> I have a question here, What are your plans with explicit ref/app
Sagi> escape flags?  Were these just left behind on this series?

We don't yet have a need for them in Linux so I didn't define them.

-- 
Martin K. Petersen	Oracle Linux Engineering
