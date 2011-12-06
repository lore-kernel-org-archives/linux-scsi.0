From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST sense to be retryable
Date: Tue, 06 Dec 2011 16:07:54 -0500
Message-ID: <yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:52498 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366Ab1LFVII (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 16:08:08 -0500
In-Reply-To: <1322857889-2623-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Fri, 2 Dec 2011 15:31:29 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Thin provisioned LUNs from multiple array vendors have failed
Mike> WRITE SAME(16) w/ UNMAP bit set with ILLEGAL_REQUEST sense.

Can you share what these arrays are returning in block limits and the
logical block provisioning VPD? It sounds like they are returning
inconsistent data causing us to issue the wrong command...

-- 
Martin K. Petersen	Oracle Linux Engineering
