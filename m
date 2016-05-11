From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] scsi_lib: Decode T-10 vendor IDs
Date: Tue, 10 May 2016 21:34:57 -0400
Message-ID: <yq17ff1pebi.fsf@sermon.lab.mkp.net>
References: <1462778069-103558-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:27584 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcEKBfN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 21:35:13 -0400
In-Reply-To: <1462778069-103558-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 9 May 2016 09:14:29 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Some arrays / HBAs will only present T-10 vendor IDs, so we
Hannes> should be decoding them, too.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
