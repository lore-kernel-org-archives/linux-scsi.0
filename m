From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv4 00/23] ALUA device handler update, part II
Date: Mon, 01 Feb 2016 21:35:08 -0500
Message-ID: <yq14mdron4z.fsf@sermon.lab.mkp.net>
References: <1453191727-3626-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:31319 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754100AbcBBCfq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2016 21:35:46 -0500
In-Reply-To: <1453191727-3626-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 19 Jan 2016 09:21:44 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@infradead.org>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> as promised here is now the second part of my ALUA device
Hannes> handler update.  This contains a major rework of the ALUA device
Hannes> handler as execution is moved onto a workqueue. This has the
Hannes> advantage that we avoid having to do multiple calls to the same
Hannes> LUN (as happens frequently when failing over a LUN with several
Hannes> paths) and finally retries are handled correctly.

I would really like to get this series merged but I need reviews for:

[PATCHv4 13/23] scsi_dh_alua: Use workqueue for RTPG
https://patchwork.kernel.org/patch/8058991/

[PATCHv4 15/23] scsi_dh_alua: Add new blacklist flag 'BLIST_SYNC_ALUA'
https://patchwork.kernel.org/patch/8058951/

[PATCHv4 22/23] scsi_dh_alua: update 'access_state' field
https://patchwork.kernel.org/patch/8059021/

-- 
Martin K. Petersen	Oracle Linux Engineering
