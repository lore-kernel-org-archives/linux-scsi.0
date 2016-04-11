From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 2/2] scsi: vpd pages are mandatory for SPC-2
Date: Mon, 11 Apr 2016 17:23:05 -0400
Message-ID: <yq1zisz262u.fsf@sermon.lab.mkp.net>
References: <1459493857-4724-1-git-send-email-hare@suse.de>
	<1459493857-4724-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22503 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652AbcDKVXT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Apr 2016 17:23:19 -0400
In-Reply-To: <1459493857-4724-3-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 1 Apr 2016 08:57:37 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> VPD pages 0x0 and 0x83 are mandatory even for SPC-2, so we
Hannes> should be lowering the restriction to avoid having to whitelist
Hannes> every SPC-2 compliant device.

Linus took patch 1/2 for 4.6rc3 so I have rebased 4.7/scsi-queue and
applied patch 2/2.

-- 
Martin K. Petersen	Oracle Linux Engineering
