From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] libfc: replace 'rp_mutex' with 'rp_lock'
Date: Tue, 10 May 2016 21:48:38 -0400
Message-ID: <yq137pppdop.fsf@sermon.lab.mkp.net>
References: <1461571293-953-1-git-send-email-hare@suse.de>
	<57322963.7040507@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:48145 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbcEKBs4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 21:48:56 -0400
In-Reply-To: <57322963.7040507@sandisk.com> (Bart Van Assche's message of
	"Tue, 10 May 2016 11:33:07 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> Is what you describe a theoretical concern or have you observed
Bart> any issues that could have been caused by the rport mutex?

I believe Ewan had some data. Ewan?

-- 
Martin K. Petersen	Oracle Linux Engineering
