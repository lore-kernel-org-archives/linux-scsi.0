From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] zfcp: Revert to original scanning behaviour
Date: Tue, 12 Apr 2016 14:39:31 -0400
Message-ID: <yq1bn5ezn6k.fsf@sermon.lab.mkp.net>
References: <1460096094-126214-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39902 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932831AbcDLSjs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2016 14:39:48 -0400
In-Reply-To: <1460096094-126214-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 8 Apr 2016 08:14:54 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Benjamin Block <bblock@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> zfcp has its own mechanism for selective scanning, so revert to
Hannes> the original scanning behaviour to not confuse users.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
