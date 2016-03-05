From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 0/6] SCSI 'access_state' attribute
Date: Sat, 05 Mar 2016 17:22:47 -0500
Message-ID: <yq1y49w36q0.fsf@sermon.lab.mkp.net>
References: <1456988052-78791-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17654 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbcCEWXC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 17:23:02 -0500
In-Reply-To: <1456988052-78791-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 3 Mar 2016 07:54:06 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, here's the patchset to add an 'access_state' and
Hannes> 'preferred_path' attribute. It will display the access state of
Hannes> a path if a hardware handler is attached.  The access_state is
Hannes> given in terms of SCSI ALUA, and the vendor-specific access
Hannes> state (eg for rdac or alua) are mapped onto the ALUA values.
Hannes> Additionally the 'is_visible' callback is updated to only
Hannes> display the attributes if they are supported.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
