From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: remove current_cmnd field from struct scsi_device
Date: Wed, 13 Jul 2016 22:34:02 -0400
Message-ID: <yq1y455kkx1.fsf@sermon.lab.mkp.net>
References: <1468211695-11917-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36711 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750866AbcGNCeJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2016 22:34:09 -0400
In-Reply-To: <1468211695-11917-1-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Mon, 11 Jul 2016 13:34:55 +0900")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> The field is only used by the 53c700 driver, so move it into
Christoph> the driver-private device data instead of having it in the
Christoph> common structure.

Applied to 4.8/scsi-queue.

-- 
Martin K. Petersen	Oracle Linux Engineering
