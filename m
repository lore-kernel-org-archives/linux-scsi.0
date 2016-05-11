From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi_dh_alua: do not fail for unknown VPD identification
Date: Tue, 10 May 2016 21:31:49 -0400
Message-ID: <yq1bn4dpegq.fsf@sermon.lab.mkp.net>
References: <1462523675-63172-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44548 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069AbcEKBdH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 21:33:07 -0400
In-Reply-To: <1462523675-63172-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 6 May 2016 10:34:35 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Paul Mackerras <paulus@ozlabs.org>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Not every device will return a useable VPD identification, but
Hannes> still might support ALUA. Rather then disable ALUA support we
Hannes> should be allowing the device identification to be empty and
Hannes> attach individual ALUA device handler to each devices.

Applied to 4.7/scsi-queue with typo fixes.

-- 
Martin K. Petersen	Oracle Linux Engineering
