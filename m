From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2 0/3] scsi trace updates
Date: Mon, 28 Mar 2016 20:32:01 -0400
Message-ID: <yq1twjqt98e.fsf@sermon.lab.mkp.net>
References: <1458829280-12518-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24995 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752033AbcC2AcL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 20:32:11 -0400
In-Reply-To: <1458829280-12518-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 24 Mar 2016 15:21:17 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> here are some some small updates to scsi tracing; it fixes the
Hannes> decoding for MAINTENANCE_IN and MAINTENANCE_OUT and adds
Hannes> definitions for the new ZBC_IN and ZBC_OUT commands.

Applied to 4.7/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
