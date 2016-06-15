From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] libfc: Update rport reference counting
Date: Tue, 14 Jun 2016 21:10:00 -0400
Message-ID: <yq1bn33cl5j.fsf@sermon.lab.mkp.net>
References: <1464070318-69866-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50912 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040AbcFOBKU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jun 2016 21:10:20 -0400
In-Reply-To: <1464070318-69866-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Tue, 24 May 2016 08:11:58 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Originally libfc would just be initializing the refcount to '1',
Hannes> and using the disc_mutex to synchronize if and when the final
Hannes> put should be happening.  This has a race condition as the mutex
Hannes> might be delayed, causing other threads to access an invalid
Hannes> structure.  This patch updates the rport reference counting to
Hannes> increase the reference every time 'rport_lookup' is called, and
Hannes> decreases the reference correspondingly.  This removes the need
Hannes> to hold 'disc_mutex' when removing the structure, and avoids the
Hannes> above race condition.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
