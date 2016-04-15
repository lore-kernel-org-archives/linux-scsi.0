From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: Declare local functions static
Date: Fri, 15 Apr 2016 16:23:23 -0400
Message-ID: <yq1vb3ipqo4.fsf@sermon.lab.mkp.net>
References: <570FD2F2.90506@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:48983 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbcDOUXq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2016 16:23:46 -0400
In-Reply-To: <570FD2F2.90506@sandisk.com> (Bart Van Assche's message of "Thu,
	14 Apr 2016 10:27:14 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Bart" == Bart Van Assche <bart.vanassche@sandisk.com> writes:

Bart> This patch avoids that building with W=1 causes gcc to report the
Bart> following type of warning:

Bart>     no previous prototype for ... [-Wmissing-prototypes]

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
