From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 00/18] ALUA device handler update, part 1
Date: Wed, 02 Dec 2015 17:00:41 -0500
Message-ID: <yq1h9k0bjee.fsf@sermon.lab.mkp.net>
References: <1448961418-29013-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22474 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756084AbbLBWBD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Dec 2015 17:01:03 -0500
In-Reply-To: <1448961418-29013-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 1 Dec 2015 10:16:40 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Bart van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Hi all, here's the first part of my ALUA device handler update.
Hannes> It's mainly bugfixes and minor improvements; the two important
Hannes> things are the addition of VPD parsing functions
Hannes> scsi_vpd_lun_id() and scsi_vpd_tpg_id().  This series has been
Hannes> split off from the original 'Asynchronous ALUA' patchset, as
Hannes> these bits are pretty uncontroversial and have a good chance of
Hannes> being merged reasonably soon.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
