From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 3/3] scsi: move the writeable from struct scsi_device to struct scsi_cd
Date: Mon, 21 Jul 2014 23:38:45 -0400
Message-ID: <yq1k376m5a2.fsf@sermon.lab.mkp.net>
References: <1405696638-23770-1-git-send-email-hch@lst.de>
	<1405696638-23770-4-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49123 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaGVDi6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Jul 2014 23:38:58 -0400
In-Reply-To: <1405696638-23770-4-git-send-email-hch@lst.de> (Christoph
	Hellwig's message of "Fri, 18 Jul 2014 17:17:18 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>

>>>>> "Christoph" == Christoph Hellwig <hch@lst.de> writes:

Christoph> We currently set the field in common code based on the device
Christoph> type, but then only use it in the cdrom driver which also
Christoph> overrides the value previously set in the generic code.

Christoph> Just leave this entirely to the CDROM driver to make
Christoph> everyones life simpler.

Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>

-- 
Martin K. Petersen	Oracle Linux Engineering
