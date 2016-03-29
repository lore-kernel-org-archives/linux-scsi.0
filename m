From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv3] scsi: disable automatic target scan
Date: Mon, 28 Mar 2016 20:27:48 -0400
Message-ID: <yq1y492t9ff.fsf@sermon.lab.mkp.net>
References: <1458200385-32088-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:23743 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755576AbcC2A2D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 20:28:03 -0400
In-Reply-To: <1458200385-32088-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 17 Mar 2016 08:39:45 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> On larger installations it is useful to disable automatic LUN
Hannes> scanning, and only add the required LUNs via udev rules.  This
Hannes> can speed up bootup dramatically.

Hannes> This patch introduces a new scan module parameter value
Hannes> 'manual', which works like 'none', but can be overriden by
Hannes> setting the 'rescan' value from scsi_scan_target to
Hannes> 'SCSI_SCAN_MANUAL'.  And it updates all relevant callers to set
Hannes> the 'rescan' value to 'SCSI_SCAN_MANUAL' if invoked via the
Hannes> 'scan' option in sysfs.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
