From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: rescan VPD attributes
Date: Mon, 30 Nov 2015 11:41:23 -0500
Message-ID: <yq1lh9figng.fsf@sermon.lab.mkp.net>
References: <1447071868-8509-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:25146 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbbK3Qlj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2015 11:41:39 -0500
In-Reply-To: <1447071868-8509-1-git-send-email-hare@suse.de> (Hannes
	Reinecke's message of "Mon, 9 Nov 2015 13:24:28 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.Petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, James Bottomley <jbottomley@odin.com>, Johannes Thumshirn <jthumshirn@suse.com>, Shane Seymour <shane.seymour@hpe.com>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> The VPD page information might change, so we need to be able to
Hannes> update it. This patch implements a VPD page rescan whenever the
Hannes> 'rescan' sysfs attribute is triggered.

Applied to 4.5/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
