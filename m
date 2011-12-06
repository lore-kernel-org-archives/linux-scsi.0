From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: scsi_error: do not allow IO errors with certain ILLEGAL_REQUEST sense to be retryable
Date: Tue, 06 Dec 2011 17:03:26 -0500
Message-ID: <yq1vcptpdch.fsf@sermon.lab.mkp.net>
References: <1322857889-2623-1-git-send-email-snitzer@redhat.com>
	<yq1zkf5pfx1.fsf@sermon.lab.mkp.net>
	<20111206212704.GB30719@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:27011 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754868Ab1LFWDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2011 17:03:42 -0500
In-Reply-To: <20111206212704.GB30719@redhat.com> (Mike Snitzer's message of
	"Tue, 6 Dec 2011 16:27:04 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>, Hannes Reinecke <hare@suse.de>

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> Regardless, shouldn't the SCSI midlayer classify such
Mike> ILLEGAL_REQUEST sense, with an add. sense I listed in the patch,
Mike> as a target error?

Well, even SUCCESS should cause the I/O to be aborted.

I assume this is the RHEL6 kernel? Did you backport my provisioning
updates that brings the heuristics in sync with SBC-3 (#c98a0e)?

-- 
Martin K. Petersen	Oracle Linux Engineering
