From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] cleanup switch in scsi_adjust_queue_depth()
Date: Wed, 25 Jun 2014 22:14:56 -0400
Message-ID: <yq1ha38ct7j.fsf@sermon.lab.mkp.net>
References: <53AA0881.5000505@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31335 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755519AbaFZCPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 22:15:05 -0400
In-Reply-To: <53AA0881.5000505@interlog.com> (Douglas Gilbert's message of
	"Tue, 24 Jun 2014 19:23:45 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>

>>>>> "Doug" == Douglas Gilbert <dgilbert@interlog.com> writes:

Doug> While checking what scsi_adjust_queue_depth() did I thought its
Doug> switch statement could be clearer.

Doug> ChangeLog:
Doug>   - remove redundant assignment (to sdev->queue_depth)
Doug>   - re-order cases (thus removing the fall-through)

Doug> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

I agree that the original version is a bit misleading.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
