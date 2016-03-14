From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: vpd pages are mandatory for SPC-2
Date: Mon, 14 Mar 2016 19:37:12 -0400
Message-ID: <yq137rshbrr.fsf@sermon.lab.mkp.net>
References: <1457703965-71028-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:45668 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751441AbcCNXh0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2016 19:37:26 -0400
In-Reply-To: <1457703965-71028-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 11 Mar 2016 14:46:05 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <james.bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes,

Hannes> VPD pages 0x0 and 0x83 are mandatory even for SPC-2, so we
Hannes> should be lowering the restriction to avoid having to whitelist
Hannes> every SPC-2 compliant device.

I wonder how many non-compliant devices we would have to blacklist as a
result of this change...

-- 
Martin K. Petersen	Oracle Linux Engineering
