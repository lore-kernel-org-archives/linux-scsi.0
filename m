From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] scsi_transport_sas: add 'scsi_target_id' sysfs attribute
Date: Mon, 14 Mar 2016 16:16:02 -0400
Message-ID: <yq1a8m0iznh.fsf@sermon.lab.mkp.net>
References: <1457948588-14558-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49690 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755882AbcCNUQT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 16:16:19 -0400
In-Reply-To: <1457948588-14558-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 14 Mar 2016 10:43:08 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Manoj Kumar <manoj@linux.vnet.ibm.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> There is no way to detect the scsi_target_id for any given SAS
Hannes> remote port, so add a new sysfs attribute 'scsi_target_id'.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
