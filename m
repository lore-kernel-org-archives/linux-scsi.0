From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv8 00/23] ALUA device handler update, part II
Date: Tue, 23 Feb 2016 20:50:09 -0500
Message-ID: <yq1egc2khbi.fsf@sermon.lab.mkp.net>
References: <1455869840-122786-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbcBXBuY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2016 20:50:24 -0500
In-Reply-To: <1455869840-122786-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Fri, 19 Feb 2016 09:16:57 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> As promised here is now the second part of my ALUA device
Hannes> handler update.  This contains a major rework of the ALUA device
Hannes> handler as execution is moved onto a workqueue. This has the
Hannes> advantage that we avoid having to do multiple calls to the same
Hannes> LUN (as happens frequently when failing over a LUN with several
Hannes> paths) and finally retries are handled correctly.  As some
Hannes> arrays are only capable of handling one STPG at a time I've
Hannes> added a blacklist flag which then uses a singlethreaded
Hannes> workqueue, thereby effectively synchronize STPG handling.
Hannes> Thanks to Bart for this suggestion.

Applied 1-19 and 23 to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
