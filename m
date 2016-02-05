From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_rdac: always retry MODE SELECT on command lock violation
Date: Thu, 04 Feb 2016 22:28:16 -0500
Message-ID: <yq1mvrfg7jj.fsf@sermon.lab.mkp.net>
References: <1453473761-54777-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34593 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722AbcBED20 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2016 22:28:26 -0500
In-Reply-To: <1453473761-54777-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 22 Jan 2016 15:42:41 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> If MODE SELECT returns with sense '05/91/36' (command lock
Hannes> violation) it should always be retried without counting the
Hannes> number of retries.  During an HBA upgrade or similar
Hannes> circumstances one might see a flood of MODE SELECT command from
Hannes> various HBAs, which will easily trigger the sense code and
Hannes> exceed the retry count.

Applied to 4.5/scsi-fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
