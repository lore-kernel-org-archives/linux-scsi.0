From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 3/5] scsi: Move sense handling routines to scsi_common
Date: Thu, 09 Jul 2015 12:16:39 -0400
Message-ID: <yq1zj35s3vc.fsf@sermon.lab.mkp.net>
References: <1436367534-15995-1-git-send-email-sagig@mellanox.com>
	<1436367534-15995-4-git-send-email-sagig@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:20113 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976AbbGIQRL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2015 12:17:11 -0400
In-Reply-To: <1436367534-15995-4-git-send-email-sagig@mellanox.com> (Sagi
	Grimberg's message of "Wed, 8 Jul 2015 17:58:52 +0300")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@mellanox.com>
Cc: linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>

>>>>> "Sagi" == Sagi Grimberg <sagig@mellanox.com> writes:

Sagi> Sense data handling is also done in the target stack.  Hence, move
Sagi> sense handling routines to scsi_common so the target will be able
Sagi> to use them as well.

I'm OK with addressing the buffer size in a separate patch.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
