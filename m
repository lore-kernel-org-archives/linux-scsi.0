From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v1 3/4] target: Return descriptor format sense data in case the LU spans 64bit sectors
Date: Wed, 15 Jul 2015 20:34:19 -0400
Message-ID: <yq1d1ztos8k.fsf@sermon.lab.mkp.net>
References: <1436946939-19415-1-git-send-email-sagig@mellanox.com>
	<1436946939-19415-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:46581 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754290AbbGPAez (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2015 20:34:55 -0400
In-Reply-To: <1436946939-19415-4-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 15 Jul 2015 10:55:38 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@HansenPartnership.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> In case a LU spans 64bit sectors, fixed size sense data
Sagi> information field is only 32 bits which means the sector
Sagi> information will be truncated.

Sagi> Thus, if the LU spans 64bit sectors, use descriptor format sense
Sagi> data to correctly report sector information.

I'm fine with Bart's suggestion.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
