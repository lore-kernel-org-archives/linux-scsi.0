From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/2] scsi: Do not attach VPD to devices that don't support it
Date: Mon, 04 Apr 2016 19:12:20 -0400
Message-ID: <yq1r3elezor.fsf@sermon.lab.mkp.net>
References: <1459493857-4724-1-git-send-email-hare@suse.de>
	<1459493857-4724-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24036 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbcDDXMd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Apr 2016 19:12:33 -0400
In-Reply-To: <1459493857-4724-2-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 1 Apr 2016 08:57:36 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The patch "scsi: rescan VPD attributes" introduced a regression
Hannes> in which devices that don't support VPD were being scanned for
Hannes> VPD attributes anyway.  This could cause issues for this parts
Hannes> and should be avoided so the check for scsi_level has been moved
Hannes> out of scsi_add_lun and into scsi_attach_vpd so that all callers
Hannes> will not scan VPD for devices that don't support it.

Applied to 4.6/scsi-fixes, CC:stable 4.5+.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
