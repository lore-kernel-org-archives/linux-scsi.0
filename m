From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 5/5] target: Return ABORTED_COMMAND sense key for PI errors
Date: Thu, 09 Jul 2015 12:21:11 -0400
Message-ID: <yq1r3ohs3ns.fsf@sermon.lab.mkp.net>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
	<1436367534-15995-6-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:25159 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbbGIQVs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 12:21:48 -0400
In-Reply-To: <1436367534-15995-6-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 17:58:54 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> PI errors were reported with ILLEGAL_REQUEST sense key but there
Sagi> was actually no problem with the request. Target detected PI
Sagi> errors should be reported with aborted command sense key.

For legacy reasons we use ILLEGAL REQUEST with the same ASC/ASCQ to
signal errors detected by the initiator. The target should always use
ABORTED COMMAND.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
