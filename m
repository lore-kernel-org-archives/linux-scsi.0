From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCHv2] scsi_sysfs: add 'is_bin_visible' callback
Date: Sat, 05 Mar 2016 17:10:52 -0500
Message-ID: <yq137s44lub.fsf@sermon.lab.mkp.net>
References: <1456987284-78634-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:51082 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750781AbcCEWLL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 5 Mar 2016 17:11:11 -0500
In-Reply-To: <1456987284-78634-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Thu, 3 Mar 2016 07:41:24 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Ewan Milne <emilne@redhat.com>, Bart van Assche <bart.vanassche@sandisk.com>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Add 'is_bin_visible' callback to blank out unsupported vpd
Hannes> pages.

Applied to 4.6/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
